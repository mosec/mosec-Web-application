class EmailAccount < Source
	GMAIL = 'gmail'

  GMAIL_HOST = 'imap.gmail.com'
  GMAIL_USE_SSL = true
  GMAIL_PORT = 993

	EMAIL_ACCOUNTS = [GMAIL]
	OAUTH_EMAIL_ACCOUNTS = [GMAIL]

	attr_accessible :email_address, :access_token, :access_secret

	validates :provider, inclusion: { in: EMAIL_ACCOUNTS }
	validates :email_address, presence: true
  validates :access_token, presence: true
  validates :access_secret, presence: true

	before_create :create_context_io_source
  
  before_destroy :destroy_context_io_source

  def host
    case self.provider
    when GMAIL
      GMAIL_HOST
    end
  end
  
  def username
    case self.provider
    when GMAIL
      self.email_address
    end
  end
  
  def use_ssl
    case self.provider
    when GMAIL
      GMAIL_USE_SSL
    end
  end
  
  def port
    case self.provider
    when GMAIL
      GMAIL_PORT
    end
  end

	private
  
  def create_context_io_source
    context_io_source_attributes = {
      'email' => self.email_address,
      'server' => self.host,
      'username' => self.username,
      'use_ssl' => self.use_ssl ? 1 : 0,
      'port' => self.port,
      'type' => CONTEXT_IO_CONFIGURATION['source_type'],
      'provider_consumer_key' => GOOGLE_CREDENTIALS['consumer_key'],
      'provider_token' => self.access_token,
      'provider_token_secret' => self.access_secret,
      'service_level' => CONTEXT_IO_CONFIGURATION['source_service_level'],
      'sync_period' => CONTEXT_IO_CONFIGURATION['source_synchronization_period'],
      'callback_url' => CONTEXT_IO_CONFIGURATION['source_callback_url']
    }
    
    context_io_source = ContextIO::Source.new(self.user.context_io_account_id, context_io_source_attributes)
    
    if context_io_source.save
      self.context_io_source_label = context_io_source.label
    else
      logger.error "Context.IO: Could not create source for user #{self.id}"
      
      self.errors[:base] << 'A problem occurred on our end. Please try again!'
    end
  end
  
  def destroy_context_io_source
    context_io_source = ContextIO::Source.find(self.user.context_io_account_id, self.context_io_source_label)
    
    unless context_io_source.destroy
      logger.error "Context.IO: Could not delete source for user #{self.id}"
      
      self.errors[:base] << 'A problem occurred on our end. Please try again!'
    end
  end
end