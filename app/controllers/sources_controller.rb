class SourcesController < ApplicationController
	before_filter :require_user

	def index
		@sources = current_user.sources
	end

	def destroy
		source = current_user.sources.find(params[:id])

		source.destroy

		redirect_to sources_url
	end
end
