# frozen_string_literal: true

class RemarkDogs < ActiveRecord::Base
  self.table_name = 'remarks_dogs'

  belongs_to :last_racing_dogs, foreign_key: 'last_racings_dogs_id'
  belongs_to :remark
  belongs_to :dog
end
