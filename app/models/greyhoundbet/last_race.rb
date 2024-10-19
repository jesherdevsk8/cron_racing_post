# frozen_string_literal: true

# Greyhoundbet::LastRace.new

require './app/models/cities'
require './app/models/dogs'
require './app/models/remarks'
require './app/models/remarks_dogs'
require './app/models/last_racings'
require './app/models/last_racings_dogs'
require './app/models/last_racings_tips'
require './app/models/statistics_by_dogs'
require './app/models/next_racings'
require './app/models/next_racings_dogs'

require './app/models/greyhoundbet/exceptions'
require './lib/api/request'

module Greyhoundbet
  class LastRace
    attr_reader :data

    def initialize(path: 'https://greyhoundbet.racingpost.com')
      raise ArgumentError, 'Data source cannot be nil or empty' if path.nil? || path.empty?

      @path = path
      @data = sync_data
    end

    attr_accessor :path

    def sync_data
      puts "Syncing LastRace data from #{path}..."

      racing_dogs = NextRacingDog.joins(:next_racing, :dog)
      all_remarks = Remark.pluck(:id, :initials).to_h

      racing_dogs.each do |racing|
        race_id_by_site = racing.next_racing.race_id_by_site
        race_date = racing.next_racing.race_date&.to_date.to_s
        dog_id_by_site = racing.dog.dog_id_by_site
        url = "#{path}/dog/blocks.sd?race_id=#{race_id_by_site}&r_date=#{race_date}&dog_id=#{dog_id_by_site}&blocks=header%2Cdetails"
        response = Api::Request.new(path: 'dog', url:)

        response.data&.each do |data|
          city = City.find_by(city_id_by_site: data[:trackId].to_i)
          city&.update_column(:short_name, data[:trackShortName])

          next unless city

          grade = data[:trialFlag] == 'NT' ? data[:rGradeCde] : data[:trialFlag]

          last_race = LastRacing.find_or_create_by(race_id_by_site: data[:rInstId].to_i, race_date: data[:raceTime],
            city_id: city.id, distance: data[:distMetre], raceGrade: grade, odd_Back: 0)

          bends = data[:bndPos].gsub(/\D/, '').chars
          fn = data[:rOutcomeId].gsub(/\D/, '')

          dog = Dog.find(racing&.dog&.id)
          last_race_dog = LastRacingDog.where(dog_id: dog&.id, last_racings_id: last_race.id).last
          next if last_race_dog

          last_race_dog = LastRacingDog.create(dog_id: dog&.id, last_racings_id: last_race.id.to_i,
            trap: data[:trapNum].to_i, final_position: fn.to_i, time: data[:calcRTimeS].to_f,
            Weight: data[:dWeightKgs].to_f, split: data[:secTimeS].to_f,
            position_bend_1: bends[0].to_i.zero? ? nil : bends[0].to_i,
            position_bend_2: bends[1].to_i.zero? ? nil : bends[1].to_i,
            position_bend_3: bends[2].to_i.zero? ? nil : bends[2].to_i,
            position_bend_4: bends[3].to_i.zero? ? nil : bends[3].to_i)

          puts('## ' * 10, { last_racings_dogs_id: last_race_dog.id })

          data[:remarks]&.split(',')&.each do |remark|
            remarkdb = Remark.find_or_create_by(initials: all_remarks[remark], remark:)
            RemarkDogs.find_or_create_by(last_racings_dogs_id: last_race_dog.id, dog_id: dog.id,
              remark_id: remarkdb.id)
          end

          statistic = StatisticByDog.find_or_initialize_by(dog_id: dog.id)
          speed = (last_race.distance / last_race_dog.time)
          statistic.total_races += 1
          statistic.sum_time_to_avg += last_race_dog.split.to_f
          statistic.sum_speed_to_avg += speed.finite? ? speed : 0
          statistic.sum_split_to_avg += last_race_dog.time.to_f

          if last_race_dog.final_position.present? && last_race_dog.final_position.to_i.between?(1, 6)
            position_column = "races_in_position_#{last_race_dog.final_position}"
            statistic.increment(position_column.to_sym)
          else
            statistic.races_without_position += 1
          end

          statistic.save!
        end
      end

      puts "LastRace data sync completed successfully. #{Time.zone.now}"
      true
    rescue StandardError => e
      puts "Error during sync LastRace data: #{e.message} - date: #{Time.zone.now}"
      nil
    end
  end
end
