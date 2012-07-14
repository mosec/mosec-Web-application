class SearchController < ApplicationController
	before_filter :require_user

	def index
		search = Search.search(params)

		@results = search.results
	end
end
