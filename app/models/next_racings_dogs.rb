class NextRacingDog < ActiveRecord::Base
  has_one :dog, foreign_key: 'dog_id', primary_key: 'id'
end
