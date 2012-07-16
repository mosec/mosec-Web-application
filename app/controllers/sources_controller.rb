class SourcesController < ApplicationController
	before_filter :require_user

	def index
		@sources = current_user.sources.not_queued_for_destruction
	end

	def create
		authentication_attributes = request.env['omniauth.auth']

		provider = authentication_attributes['provider']

		if EmailAccount::EMAIL_ACCOUNTS.include?(provider)
			email_account = current_user.email_accounts.where(provider: provider, uid: authentication_attributes['uid']).first

			unless email_account
				email_account = current_user.email_accounts.create_with_omniauth(authentication_attributes)
			end
		end

		redirect_to linked_accounts_url
	end

	def destroy
		source = current_user.sources.find(params[:id])

		Resque.enqueue(DestroySource, current_user.id, source.id)

		redirect_to linked_accounts_url
	end
end
