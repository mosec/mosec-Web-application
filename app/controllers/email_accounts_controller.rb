class EmailAccountsController < ApplicationController
  def ready
    user = User.where(context_io_account_id: params['account_id']).first
    
    if user
      # stub
    end
    
    render :status => :ok, :nothing => true
  end
end
