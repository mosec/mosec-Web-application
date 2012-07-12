class Contact < ActiveRecord::Base
  include Expect
  
	belongs_to :contactable, polymorphic: true

	attr_accessible :uid, :full_name

	validates :uid, presence: true, uniqueness: { scope: [:contactable_id, :contactable_type] }
  validates :full_name, presence: true

  has_many :phone_numbers, dependent: :destroy
  has_many :email_addresses, dependent: :destroy

  # phone_numbers parameter is an array of strings or a string
  def add_phone_numbers!(list_of_phone_numbers)
    phone_numbers = Expect.normalize_string_to_array(list_of_phone_numbers)
    
    phone_numbers.each do |phone_number|
      add_phone_number!(phone_number)
    end
  end
  
  # phone_number parameter is a string
  def add_phone_number!(phone_number)
    clean_phone_number = Expect.clean_phone_number(phone_number)
    
    unless self.phone_numbers.where(clean_phone_number: clean_phone_number).any?
      self.phone_numbers.create(phone_number: phone_number)
    end
  end
  
  # list_of_phone_numbers parameter is an array of strings or a string
  def remove_phone_numbers_not_in_list!(list_of_phone_numbers)
    clean_phone_numbers = Expect.normalize_string_to_array(list_of_phone_numbers).map {|phone_number| Expect.clean_phone_number(phone_number) }
    
    self.phone_numbers.where('clean_phone_number NOT IN (?)', clean_phone_numbers).map(&:destroy)
  end
  
  # email_addresses parameter is an array of strings or a string
  def add_email_addresses!(list_of_email_addresses)
    email_addresses = Expect.normalize_string_to_array(list_of_email_addresses)
    
    email_addresses.each do |email_address|
      add_email_address!(email_address)
    end
  end
  
  # email_address parameter is a string
  def add_email_address!(email_address)
    unless self.email_addresses.where(email_address: email_address).any?
      self.email_addresses.create(email_address: email_address)
    end
  end
  
  def remove_email_addresses_not_in_list!(list_of_email_addresses)
    email_addresses = Expect.normalize_string_to_array(list_of_email_addresses)
    
    self.email_addresses.where('email_address NOT IN (?)', email_addresses).map(&:destroy)
  end
end
