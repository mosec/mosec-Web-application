class DashboardsController < ApplicationController
	before_filter :require_user

  def show
  	@contacts = current_user.contacts.alphabetical
  	
  	@activities = Search.search(current_user.id, params).results
  end
end
