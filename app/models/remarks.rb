# frozen_string_literal: true

class Remark < ActiveRecord::Base
  has_many :remark_dogs, foreign_key: 'remark_id'
end
