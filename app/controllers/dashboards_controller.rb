class DashboardsController < ApplicationController
	before_filter :require_user

  def show
  	# TODO: user.phones.first.contacts
  	@contacts = current_user.phones.first.contacts
  end
end
