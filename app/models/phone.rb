class Phone < Source
  attr_accessible :operating_system

	ANDROID = 'android'

  PHONES = [ANDROID]

  validates :provider, inclusion: { in: PHONES }

  def operating_system=(operating_system)
    self.provider = operating_system
  end
end