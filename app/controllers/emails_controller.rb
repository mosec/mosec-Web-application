class EmailsController < ApplicationController
  def create
    signature = params['signature']

    token = params['token']
    timestamp = params['timestamp']

    if signature == OpenSSL::HMAC.hexdigest('sha256', CONTEXT_IO_CONFIGURATION['consumer_secret'], timestamp.to_s + token)
      user = User.where(context_io_web_hook_id: params['webhook_id']).first
      
      # stub
      
      render status: :ok, nothing: true
    else
      render status: :unauthorized, nothing: true
    end
  end
  
  def failure
    user = User.where(context_io_web_hook_id: params['id']).first
    
    if user
      user.create_context_io_web_hook
    end
    
    render status: :ok, nothing: true
  end
end
