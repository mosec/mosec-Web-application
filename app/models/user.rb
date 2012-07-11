class User < ActiveRecord::Base
  attr_accessible :email_address, :password, :time_zone

  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  has_secure_password

  has_many :sources, dependent: :delete_all
  has_many :phones
end
