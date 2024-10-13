# frozen_string_literal: true

module NextRace
  class Error < StandardError; end
  class ApiRequestError < Error; end

  class NoContent < Error
    def initialize(message = 'No content found')
      super
    end
  end
end
