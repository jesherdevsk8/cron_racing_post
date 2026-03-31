# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require_relative '../greyhoundbet'
require_relative 'exceptions'

module Api
  class Service
    DEFAULT_HEADERS = {
      'Accept' => 'application/json, text/plain, */*',
      'Accept-Language' => 'en-GB,en;q=0.9',
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
      'Referer' => "#{Greyhoundbet::BASE_URL}/"
    }.freeze

    def self.get(url)
      uri = URI.parse(url)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new(uri)
        DEFAULT_HEADERS.each { |key, value| request[key] = value }
        http.request(request)
      end

      raise RequestError, "The server responded with HTTP #{response.code}" unless response.code == '200'

      JSON.parse(response.body).with_indifferent_access
    end
  end
end
