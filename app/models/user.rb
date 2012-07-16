class User < ActiveRecord::Base
  attr_accessible :full_name, :email_address, :password, :time_zone

  validates :full_name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  has_secure_password

  has_many :sources, dependent: :destroy do
    def create_with_omniauth(authentication_attributes)
      proxy_association.create({
        provider: authentication_attributes['provider'],
        uid: authentication_attributes['uid']
      })
    end
  end
  has_many :phones
  has_many :email_accounts

  # TODO: make more flexible
  has_many :contacts, through: :phones
  has_many :calls, through: :phones
  has_many :text_messages, through: :phones
  has_many :calendar_events, through: :phones
end
