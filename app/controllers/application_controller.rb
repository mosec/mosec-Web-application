class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  protected

  def current_user
  	begin
  		@user ||= User.find(cookies.signed[:user_id]) if cookies.signed[:user_id]
  	rescue ActiveRecord::RecordNotFound
  	end
  end

  def require_no_user
    if current_user
      respond_to do |format|
        format.html { redirect_to dashboard_url }
        format.json { render status: :forbidden, nothing: true }
      end
    end
  end
  
  def require_user
    unless current_user
      respond_to do |format|
        format.html { redirect_to sign_in_url }
        format.json { render status: :unauthorized, nothing: true }
      end
    end
  end

  # Must be signed in to use this method
  def current_phone
    @phone ||= current_user.phones.find(cookies.signed[:phone_id]) if cookies.signed[:phone_id]
  end
  
  def require_phone
    unless current_phone
      respond_to do |format|
        format.json { render status: :forbidden, nothing: true }
      end
    end
  end
end
