# frozen_string_literal: true

class StatisticByDog < ActiveRecord::Base
  self.table_name = 'statistics_by_dogs'
  self.primary_key = 'dog_id'

  validates :dog_id, presence: true
end
