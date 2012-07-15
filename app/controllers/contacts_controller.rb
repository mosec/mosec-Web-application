class ContactsController < ApplicationController
	before_filter :require_user

	def show
		# TODO: user.phones.first.contacts
		@contact = current_user.phones.first.contacts.find(params[:id])

		params[:contact_id] = params[:id]
		params.delete(:id)

		@activities = Search.search(current_user.id, params).results
	end
end
