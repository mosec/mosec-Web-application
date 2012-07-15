class DashboardsController < ApplicationController
	before_filter :require_user

  def show
  	# TODO: user.phones.first.contacts
  	if current_user.phones.first
	  	@contacts = current_user.phones.first.contacts.alphabetical
	  	
	  	@activities = Search.search(current_user.id, params).results
	  end
  end
end
