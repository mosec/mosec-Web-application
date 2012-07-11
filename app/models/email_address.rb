class EmailAddress < ActiveRecord::Base
  belongs_to :contact
  
  attr_accessible :email_address
  
  validates :email_address, presence: true, uniqueness: { scope: :contact_id }
end
