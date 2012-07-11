class PhoneDataController < ApplicationController
  include Expect
  
  before_filter :require_user
  before_filter :require_phone
  
  def synchronize
    type = params[:phone_data][:type]
    data = params[:phone_data][:data]
    
    job_data = [current_user.id, current_phone.id, data]
    
    case type
    when Expect.normalize_class_to_string(Contact)
      Resque.enqueue(SynchronizePhoneContacts, *job_data)
    end
    
    render status: :ok, nothing: true
  end
end
