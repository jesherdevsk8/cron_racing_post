# frozen_string_literal: true

class Dog < ActiveRecord::Base
  belongs_to :site
end
