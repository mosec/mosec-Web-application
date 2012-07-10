class User < ActiveRecord::Base
  attr_accessible :email_address, :password

  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  has_secure_password
end
