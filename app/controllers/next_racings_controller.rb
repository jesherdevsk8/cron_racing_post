# frozen_string_literal: true

require './app/models/next_racings'

class NextRacingsController
  def self.index
    NextRacing.order(:race_date).to_json
  end
end
