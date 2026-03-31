# frozen_string_literal: true

get '/dogs' do
  content_type :json
  DogsController.index(params).to_json
end

get '/next_racings' do
  content_type :json
  NextRacingsController.index(params).to_json
end
