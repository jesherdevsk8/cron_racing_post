# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv/load'

# require "./app/controllers/galgo_controller"

# health check route
get '/health' do
  status 200
  json message: 'OK', status: 'healthy'
end

get '/' do
  json message: 'hello galgo'
end
