class SourcesController < ApplicationController
	before_filter :require_user

	def index
		@sources = current_user.sources.not_queued_for_destruction
	end

	def destroy
		source = current_user.sources.find(params[:id])

		Resque.enqueue(DestroySource, current_user.id, source.id)

		redirect_to services_url
	end
end
