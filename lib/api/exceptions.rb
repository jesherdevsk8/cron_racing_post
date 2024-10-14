# frozen_string_literal: true

module Api
  class Error < StandardError; end
  class RequestError < Error; end

  class NoContent < Error
    def initialize(message = 'No content found')
      super
    end
  end
end
