# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'dotenv/load'

Time.zone = 'America/Sao_Paulo'

ROOT_PATH = File.expand_path(__dir__)

# Require all controller files
Dir.glob(File.join(ROOT_PATH, 'app', 'controllers', '**', '*.rb')).each do |file|
  require file
end

require File.join(ROOT_PATH, 'config', 'routes')
require File.join(ROOT_PATH, 'config', 'cors')

# health check route
get '/health' do
  status 200
  content_type :json
  { message: 'OK', status: 'healthy' }.to_json
end

get '/' do
  content_type :json
  { message: 'hello Greyhound' }.to_json
end
