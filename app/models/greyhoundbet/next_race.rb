# frozen_string_literal: true

# Greyhoundbet::NextRace.new

require './app/models/cities'
require './app/models/dogs'
require './app/models/next_racings'
require './app/models/next_racings_dogs'
require './app/models/next_racings_tips'
require './app/models/statistics_by_dogs'
require './app/models/sites'

require './app/models/greyhoundbet/exceptions'
require './lib/api/request'

module Greyhoundbet
  class NextRace
    attr_reader :data

    def initialize(path: 'https://greyhoundbet.racingpost.com')
      raise ArgumentError, 'Data source cannot be nil or empty' if path.nil? || path.empty?

      @path = path
      @data = sync_data
    end

    attr_accessor :path

    def sync_data
      puts "Syncing NextRace data from #{path}..."

      racings = []

      ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0;')
      NextRacing.delete_all
      NextRacingDog.delete_all
      NextRacingTip.delete_all
      ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1;')

      site = Site.find_or_create_by(site: Site::NAMES[:greyhoundbet],
        by_name: Site::NAMES[:greyhoundbet])

      Time.zone = 'America/Sao_Paulo'
      date = Time.zone.now.to_date.to_s

      url = "#{path}/meeting/blocks.sd?view=meetings&r_date=#{date}&blocks=header%2Clist"
      response = Api::Request.new(path: 'meeting', url:)
      response_data = response.data

      response_data.each do |data|
        city = City.find_or_create_by(city_id_by_site: data[:track_id],
          city: data[:track], site_id: site.id)

        data[:races].each do |race|
          card_url = "#{path}/card/blocks.sd?track_id=#{data[:track_id]}&race_id=#{race[:raceId]}&r_date=#{date}&tab=card&blocks=%2Ccard-tabs%2Ccard"

          response = Api::Request.new(path: 'card', url: card_url)
          response_dogs = response.data&.dig(:card, :dogs)
          card_tabs = response.data[:'card-tabs']

          raise NoDogsError unless response_dogs

          racings << {
            racing: {
              race_date: race[:raceDate],
              race_id_by_site: race[:raceId],
              grade: race[:raceGrade],
              distance: race[:distance].gsub(/[^\d]/, ''),
              city_id: city.id
            },
            dogs: [],
            tips: {
              first_tip: card_tabs[:selTrapNum],
              second_tip: card_tabs[:dangerTrapNum],
              third_tip: card_tabs[:fcastAltTrapNum]
            }
          }.with_indifferent_access

          response_dogs.each do |dog_data|
            dog = Dog.find_or_create_by(dog_id_by_site: dog_data[:dogId], name: dog_data[:dogName],
              sex: dog_data[:dogSex], color: dog_data[:dogColor],
              dateOfBirth: Date.parse(dog_data[:dateOfBirth]))

            statistic = StatisticByDog.find_or_initialize_by(dog_id: dog.id)
            statistic.top_speed = dog_data[:brt]

            statistic.save!

            racings.last[:dogs] << {
              dog_id: dog.id,
              trap: dog_data[:trapNum]
            }
          end

          next_racing = NextRacing.find_or_create_by(racings.last[:racing])
          NextRacingTip.find_or_create_by(next_racings_id: next_racing.id, site_id: site.id,
                                          **racings.last[:tips].symbolize_keys)

          racings.last[:dogs].each do |dog|
            dog[:next_racings_id] = next_racing.id
            NextRacingDog.create!(dog)
          end
        end
      end

      puts "NextRace data sync completed successfully. #{Time.zone.now} - #{Time.zone.name}"
      true
    rescue StandardError => e
      puts "Error during sync NextRace data: #{e.message} - date: #{Time.zone.now} - #{Time.zone.name}"
      nil
    end
  end
end
