class User < ActiveRecord::Base
  attr_accessible :full_name, :email_address, :password, :time_zone

  validates :full_name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  has_secure_password

  before_create :create_context_io_account
  before_create :create_context_io_web_hook

  has_many :sources, dependent: :destroy
  has_many :phones
  has_many :email_accounts do
    def create_with_omniauth(authentication_attributes)
      provider = authentication_attributes['provider']
      uid = authentication_attributes['uid']

      additional_options = {}

      if EmailAccount::OAUTH_EMAIL_ACCOUNTS.include?(provider)
        email_address = authentication_attributes['info']['email']
        access_token = authentication_attributes['credentials']['token']
        access_secret = authentication_attributes['credentials']['secret']

        additional_options.merge!({ email_address: email_address,
                                    access_token: access_token,
                                    access_secret: access_secret })
      end
      
      proxy_association.create({
        provider: provider,
        uid: uid
      }.merge(additional_options))
    end
  end

  # TODO: make more flexible
  has_many :contacts, through: :phones
  has_many :calls, through: :phones
  has_many :text_messages, through: :phones
  has_many :calendar_events, through: :phones

  def create_context_io_web_hook
    all_web_hooks_destroyed = ContextIO::Webhook.all(self.context_io_account_id).map(&:destroy).all? {|web_hook_destroyed| web_hook_destroyed }
    
    if all_web_hooks_destroyed
      web_hook = ContextIO::Webhook.new(self.context_io_account_id, { callback_url: CONTEXT_IO_CONFIGURATION['web_hook_callback_url'],
                                                                      failure_notif_url: CONTEXT_IO_CONFIGURATION['web_hook_failure_notification_url'],
                                                                      sync_period: CONTEXT_IO_CONFIGURATION['web_hook_synchronization_period'] })
      
      if web_hook.save
        self.context_io_web_hook_id = web_hook.webhook_id
      else
        logger.error "There was a problem creating a Context.IO web hook for #{self.email_address}"
        
        self.errors[:base] << 'A problem occurred on our end. Please try again!'

        false
      end
    else  
      logger.error "There was a problem destroying all web hooks for #{self.email_address}"
      
      self.errors[:base] << 'A problem occurred on our end. Please try again!'

      false
    end
  end
  
  private
  
  def create_context_io_account
    begin
      account = ContextIO::Account.all(:email => self.email_address).first
    
      if account
        self.context_io_account_id = account.id
      else
        account = ContextIO::Account.new(:email => self.email_address)
      
        if account.save
          self.context_io_account_id = account.id
        else
          logger.error "There was a problem creating a Context.IO account for #{self.email_address}"
          
          self.errors[:base] << 'A problem occurred on our end. Please try again!'
          
          false
        end
      end
    rescue
      logger.error "There was a problem creating a Context.IO account potentially due to a malformed email for #{self.email_address}"
      
      false
    end
  end
end
