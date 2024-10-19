# frozen_string_literal: true

class LastRacingDog < ActiveRecord::Base
  self.table_name = 'last_racings_dogs'

  belongs_to :last_racing, foreign_key: 'last_racings_id'
  belongs_to :dog
end
