# frozen_string_literal: true

require './app/models/dogs'
require './app/controllers/pagination'

class DogsController
  def self.index(params = {})
    page = [params[:page].to_i, 1].max
    per_page = Pagination::PER_PAGE
    scope = Dog.order(id: :desc)
    total = scope.count
    dogs = scope.limit(per_page).offset((page - 1) * per_page)

    {
      dogs: JSON.parse(dogs.to_json),
      pagination: {
        page:,
        per_page:,
        total:,
        total_pages: (total + per_page - 1) / per_page
      }
    }
  end
end
