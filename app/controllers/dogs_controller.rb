# frozen_string_literal: true

require './app/models/dogs'

class DogsController
  def self.index
    Dog.order(:name).to_json
  end
end
