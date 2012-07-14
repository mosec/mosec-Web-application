class Call < ActiveRecord::Base
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