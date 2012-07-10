class UsersController < ApplicationController
	before_filter :require_no_user

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])

		if @user.save
			cookies.signed.permanent[:user_id] = @user.id

			redirect_to dashboard_url
		else
			render :new
		end
	end
end
