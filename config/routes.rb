# frozen_string_literal: true

get '/dogs' do
  content_type :json
  { dogs: JSON.parse(DogsController.index) }.to_json
end

get '/next_racings' do
  content_type :json
  { next_racings: JSON.parse(NextRacingsController.index) }.to_json
end
