class User < ActiveRecord::Base
  attr_accessible :full_name, :email_address, :password, :time_zone

  validates :full_name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  has_secure_password

  has_many :sources, dependent: :destroy
  has_many :phones

  # TODO: make more flexible
  has_many :contacts, through: :phones
  has_many :calls, through: :phones
  has_many :text_messages, through: :phones
  has_many :calendar_events, through: :phones
end
