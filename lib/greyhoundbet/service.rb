# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require_relative 'exceptions'

module Greyhoundbet
  class Service
    def self.get(url)
      uri = URI.parse(url)

      response = Net::HTTP.get_response(uri)

      raise ApiRequestError, "The server responded with HTTP #{response.code}" unless response.code == '200'

      JSON.parse(response.body).with_indifferent_access
    end
  end
end
