# frozen_string_literal: true

class NextRacing < ActiveRecord::Base
  has_many :next_racing_dogs, foreign_key: 'next_racings_id', primary_key: 'id'
end
