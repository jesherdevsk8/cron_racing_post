# frozen_string_literal: true

require 'sinatra/activerecord/rake'
Dir.glob('lib/tasks/*.rake').each { |rake| load rake }

namespace :db do
  task load_config: :environment do
    require './server'
  end
end