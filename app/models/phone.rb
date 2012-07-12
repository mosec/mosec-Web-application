class Phone < Source
	ANDROID = 'android'

  PHONES = [ANDROID]

  attr_accessible :operating_system

  validates :provider, inclusion: { in: PHONES }

  before_create :prepare_last_synchronizeds_attribute

  has_many :contacts, as: :contactable, dependent: :destroy

  def operating_system=(operating_system)
    self.provider = operating_system
  end

  def last_synchronized
  	[contacts_last_synchronized, calls_last_synchronized, text_messages_last_synchronized, calendar_events_last_synchronized].compact!.max
  end

  def contacts_last_synchronized
  	self.last_synchronizeds['contacts'].try(:to_datetime)
  end

  def contacts_last_synchronized=(contacts_last_synchronized)
  	self.last_synchronizeds['contacts'] = contacts_last_synchronized
  end

  def calls_last_synchronized
  	self.last_synchronizeds['calls'].try(:to_datetime)
  end

  def calls_last_synchronized=(calls_last_synchronized)
  	self.last_synchronizeds['calls'] = calls_last_synchronized
  end

  def text_messages_last_synchronized
  	self.last_synchronizeds['text_messages'].try(:to_datetime)
  end

  def text_messages_last_synchronized=(text_messages_last_synchronized)
  	self.last_synchronizeds['text_messages'] = text_messages_last_synchronized
  end

  def calendar_events_last_synchronized
  	self.last_synchronizeds['calendar_events'].try(:to_datetime)
  end

  def calendar_events_last_synchronized=(calendar_events_last_synchronized)
  	self.last_synchronizeds['calendar_events'] = calendar_events_last_synchronized
  end

  private

  def prepare_last_synchronizeds_attribute
  	self.last_synchronizeds = { 'contacts' => nil, 'calls' => nil, 'text_messages' => nil, 'calendar_events' => nil }
  end
end