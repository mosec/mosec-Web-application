class Call < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Expect
  
  belongs_to :phone
  
  attr_accessible :uid, :call_type, :phone_number, :duration, :time
  
  INCOMING = 'incoming'
	OUTGOING = 'outgoing'
	MISSED = 'missed'

	CALL_TYPES = [INCOMING, OUTGOING, MISSED]
  
  validates :uid, presence: true, uniqueness: { scope: :phone_id }
  validates :call_type, presence: true, inclusion: { in: CALL_TYPES }
  validates :phone_number, presence: true
  validates :clean_phone_number, presence: true
  validates :duration, presence: true, numericality: true
  validates :time, presence: true, numericality: true

  mapping do
    indexes :user_id, type: :integer, index: :not_analyzed, include_in_all: false, as: Proc.new { user_id }
    indexes :contact_ids, type: :integer, index: :not_analyzed, include_in_all: false, as: Proc.new { contact_ids }
    indexes :call_type, type: :string, include_in_all: false
    indexes :phone_number, type: :string, include_in_all: false
    indexes :clean_phone_number, type: :string, include_in_all: false
    indexes :duration, type: :integer, include_in_all: false
    indexes :time, type: :date, include_in_all: false
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
    self.call_type == INCOMING
  end
  
  def outgoing?
    self.call_type == OUTGOING
  end
  
  def missed?
    self.call_type == MISSED
  end
end
