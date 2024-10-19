# frozen_string_literal: true

class NextRacingDog < ActiveRecord::Base
  self.table_name = 'next_racings_dogs'

  belongs_to :next_racing, foreign_key: 'next_racings_id'
  belongs_to :dog, foreign_key: 'dog_id', primary_key: 'id'
end
