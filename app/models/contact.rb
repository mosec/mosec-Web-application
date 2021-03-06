class Contact < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Expect

	belongs_to :contactable, polymorphic: true

  scope :alphabetical, order('full_name ASC')

	attr_accessible :uid, :full_name

	validates :uid, presence: true, uniqueness: { scope: [:contactable_id, :contactable_type] }
  validates :full_name, presence: true

  has_many :phone_numbers, dependent: :destroy
  has_many :email_addresses, dependent: :destroy

  settings analysis: {
    filter: {
      ngram_filter: {
        type: 'nGram',
        min_gram: 3,
        max_gram: 10
      }
    },
    analyzer: {
      ngram_analyzer: {
        tokenizer: :lowercase,
        filter: [:ngram_filter],
        type: :custom
      }
    }
  } do 
    mapping _all: { analyzer: :ngram_analyzer } do
      indexes :user_id, type: :integer, index: :not_analyzed, include_in_all: false, as: Proc.new { user_id }
      indexes :full_name, type: :string, analyzer: :ngram_analyzer
    end
  end

  def user_id
    self.contactable.user.id
  end

  # phone_numbers parameter is a comma-separated list of strings or a string
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
  
  # list_of_phone_numbers parameter is a comma-separated list of strings or a string
  def remove_phone_numbers_not_in_list!(list_of_phone_numbers)
    clean_phone_numbers = Expect.normalize_string_to_array(list_of_phone_numbers).map {|phone_number| Expect.clean_phone_number(phone_number) }
    
    if clean_phone_numbers.any?
      self.phone_numbers.where('clean_phone_number NOT IN (?)', clean_phone_numbers).map(&:destroy)
    else
      self.phone_numbers.destroy_all
    end
  end
  
  # email_addresses parameter is a comma-separated list of strings or a string
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
    
    if email_addresses.any?
      self.email_addresses.where('email_address NOT IN (?)', email_addresses).map(&:destroy)
    else
      self.email_addresses.destroy_all
    end
  end
end
