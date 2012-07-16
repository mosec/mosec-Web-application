class SourcesController < ApplicationController
	before_filter :require_user

	def index
		@sources = current_user.sources.not_queued_for_destruction
	end

	def create
		authentication_attributes = request.env['omniauth.auth']

		source = current_user.sources.where(provider: authentication_attributes['provider'], uid: authentication_attributes['uid']).first

		unless source
			source = current_user.sources.create_with_omniauth(authentication_attributes)
		end

		redirect_to linked_accounts_url
	end

	def destroy
		source = current_user.sources.find(params[:id])

		Resque.enqueue(DestroySource, current_user.id, source.id)

		redirect_to linked_accounts_url
	end
end
