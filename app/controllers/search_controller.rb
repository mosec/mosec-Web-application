class SearchController < ApplicationController
	before_filter :require_user

	def index
		search = Search.search(current_user.id, params)

		@results = search.results
	end
end
