# frozen_string_literal: true

require_relative 'service'
require_relative 'exceptions'

module Api
  class Request
    attr_reader :path, :url, :data

    def initialize(path: '', url: '')
      raise ArgumentError 'url must not be nil' if url.nil? || url.to_s.empty?
      raise ArgumentError 'path must not be nil' if path.nil? || path.to_s.empty?

      response = Service.get(url)

      @data = rows_from(path, response)
    end

    private

    def rows_from(path, response)
      case path.to_sym
      when :meeting
        items = response&.dig(:list, :items)
        raise NoContent unless items

        items
      when :dog
        forms = response&.dig(:details, :forms)
        raise NoContent unless forms

        forms
      when :card
        raise NoContent unless response

        response
      end
    end
  end
end
