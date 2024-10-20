# frozen_string_literal: true

# Configuration of middleware CORS
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any, methods: [:get]
  end
end
