class UserSessionsController < ApplicationController
	before_filter :require_no_user, only: [:new, :create]
  before_filter :require_user, only: [:destroy]

  def new
    @user = User.new
  end

  # Hitting the JSON endpoint means the user is signing in on a phone
  def create
    @user = User.where(email_address: params[:user_session][:email_address]).first
    
    if @user.try(:authenticate, params[:user_session][:password])
      cookies.signed.permanent[:user_id] = @user.id
      
      respond_to do |format|
        format.html {
          redirect_to dashboard_url
        }
        format.json {
          phone = current_user.sources.where(provider: params[:source][:provider], uid: params[:source][:uid]).first

          unless phone
            phone = current_user.sources.create!(params[:source])
          end

          cookies.signed.permanent[:phone_id] = phone.id

          render status: :ok
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = 'Incorrect email address and password combination.'
          
          render :new
        }
        format.json {
          @user = User.new

          @user.errors[:base] << 'Incorrect email address and password combination.'
          
          render status: :unauthorized, action: :create_errors
        }
      end
    end
  end
  
  def destroy
    cookies.signed[:user_id] = nil
    
    redirect_to root_url
  end
end
