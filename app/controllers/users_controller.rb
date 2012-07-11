class UsersController < ApplicationController
	before_filter :require_no_user

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])

		time_zone = ActiveSupport::TimeZone::MAPPING.select {|key, value| value == params[:dirty_time_zone] }.first

		# time zone was found
    if time_zone
      @user.time_zone = time_zone[0]
    end

		if @user.save
			cookies.signed.permanent[:user_id] = @user.id

			redirect_to dashboard_url
		else
			render :new
		end
	end
end
