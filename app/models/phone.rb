class Phone < Source
  attr_accessible :operating_system

	ANDROID = 'android'

  PHONES = [ANDROID]

  validates :provider, inclusion: { in: PHONES }

  has_many :contacts, as: :contactable, dependent: :delete_all

  def operating_system=(operating_system)
    self.provider = operating_system
  end
end