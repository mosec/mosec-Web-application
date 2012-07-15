class TextMessage < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Expect
  
  belongs_to :phone
  
  attr_accessible :uid, :text_message_type, :thread_id, :phone_number, :body, :time
  
  INBOX = 'inbox'
	SENT = 'sent'

	TEXT_MESSAGE_TYPES = [INBOX, SENT]
	
	validates :uid, presence: true, uniqueness: { scope: :phone_id }
	validates :text_message_type, :presence => true, :inclusion => { :in => TEXT_MESSAGE_TYPES }
  validates :thread_id, :presence => true
  validates :phone_number, :presence => true
  validates :clean_phone_number, :presence => true
  validates :body, :presence => true
  validates :time, :presence => true, :numericality => true

  mapping do
    indexes :user_id, type: :integer, include_in_all: false, as: Proc.new { user_id }
    indexes :contact_ids, type: :integer, include_in_all: false, as: Proc.new { contact_ids }
    indexes :phone_number, type: :string, include_in_all: false
    indexes :clean_phone_number, type: :string, include_in_all: false
    indexes :text_message_type, type: :string, include_in_all: false
    indexes :thread_id, type: :string, include_in_all: false
    indexes :body, type: :string
  end

  def user_id
    self.phone.user.id
  end

  def contact_ids
    self.phone.user.contacts.includes(:phone_numbers).where(:phone_numbers => { :clean_phone_number => self.clean_phone_number }).collect {|contact| contact.id }
  end

  # phone_number parameter is a string
  def phone_number=(phone_number)
    super(phone_number)
    
    self.clean_phone_number = Expect.clean_phone_number(phone_number)
  end

  def time=(time)
    self[:time] = Time.at(time).to_datetime
  end
  
  def incoming?
    self.text_message_type == INBOX
  end
  
  def outgoing?
    self.text_message_type == SENT
  end
end
