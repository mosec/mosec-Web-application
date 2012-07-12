class Source < ActiveRecord::Base
	belongs_to :user

	serialize :last_synchronizeds, ActiveRecord::Coders::Hstore

  attr_accessible :provider, :uid

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
end
