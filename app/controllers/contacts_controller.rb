class ContactsController < ApplicationController
	before_filter :require_user

	def show
		# TODO: user.phones.first.contacts
		@contact = current_user.phones.first.contacts.find(params[:id])
	end
end
