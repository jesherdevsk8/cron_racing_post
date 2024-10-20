# frozen_string_literal: true

# bundle exec ruby run_last_race.rb >> cron.log 2>&1

require 'sinatra/activerecord'
require './app/models/greyhoundbet/last_race'

Greyhoundbet::LastRace.new
