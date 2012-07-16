class Source < ActiveRecord::Base
	belongs_to :user

	scope :not_queued_for_destruction, where(:queued_for_destruction => false)

	serialize :last_synchronizeds, ActiveRecord::Coders::Hstore

  attr_accessible :provider, :uid

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  def provider=(provider)
  	super(provider)

  	if Phone::PHONES.include?(provider)
  		self.type = 'Phone'
  	elsif EmailAccount::EMAIL_ACCOUNTS.include?(provider)
  		self.type = 'EmailAccount'
  	end
  end
end
