# frozen_string_literal: true

# bundle exec ruby run_next_race.rb >> cron.log 2>&1

require 'sinatra/activerecord'
require './app/models/greyhoundbet/next_race'

Greyhoundbet::NextRace.new
