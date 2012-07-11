class PhoneNumber < ActiveRecord::Base
  include Expect
  
  belongs_to :contact
  
  attr_accessible :phone_number
  
  validates :phone_number, presence: true
  validates :clean_phone_number, presence: true, uniqueness: { scope: :contact_id }
  
  # phone_number parameter is a string
  def phone_number=(phone_number)
    super(phone_number)
    
    self.clean_phone_number = Expect.clean_phone_number(phone_number)
  end
end
