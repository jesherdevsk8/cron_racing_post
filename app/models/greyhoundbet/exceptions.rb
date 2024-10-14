# frozen_string_literal: true

module Greyhoundbet
  class Error < StandardError; end

  class NoDogsError < Error
    def initialize(message = 'no dogs available')
      super
    end
  end
end
