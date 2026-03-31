# frozen_string_literal: true

require './app/models/next_racings'
require './app/controllers/pagination'

class NextRacingsController
  def self.index(params = {})
    page = [params[:page].to_i, 1].max
    per_page = Pagination::PER_PAGE
    scope = NextRacing.order(:race_date)
    total = scope.count
    next_racings = scope.limit(per_page).offset((page - 1) * per_page)

    {
      next_racings: JSON.parse(next_racings.to_json),
      pagination: {
        page:,
        per_page:,
        total:,
        total_pages: (total + per_page - 1) / per_page
      }
    }
  end
end
