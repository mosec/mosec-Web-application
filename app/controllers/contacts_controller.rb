class ContactsController < ApplicationController
	before_filter :require_user

	def show
		@contact = current_user.contacts.find(params[:id])

		params[:contact_id] = params[:id]

		@activities = Search.search(current_user.id, params).results
	end
end
