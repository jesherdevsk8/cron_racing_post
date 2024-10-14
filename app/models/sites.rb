# frozen_string_literal: true

class Site < ActiveRecord::Base
  NAMES = {
    time_form: 'TimeForm',
    greyhoundbet: 'greyhoundbet'
  }.freeze
end
