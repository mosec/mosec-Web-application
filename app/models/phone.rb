class Phone < Source
	ANDROID = 'android'

  PHONES = [ANDROID]

  validates :provider, inclusion: { in: PHONES }

  before_create :prepare_last_synchronizeds_attribute

  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :calls, dependent: :destroy
  has_many :text_messages, dependent: :destroy
  has_many :calendar_events, as: :eventable, dependent: :destroy

  def last_synchronized
  	[contacts_last_synchronized, calls_last_synchronized, text_messages_last_synchronized, calendar_events_last_synchronized].compact.max
  end

  %w(contacts_last_synchronized calls_last_synchronized text_messages_last_synchronized calendar_events_last_synchronized).each do |method|
  	define_method(method) do
  		match = /\A(?<data_type>\w+)_last_synchronized\Z/.match(method)

  		self.last_synchronizeds[match[:data_type]].try(:to_datetime)
  	end
  end

  %w(contacts_last_synchronized= calls_last_synchronized= text_messages_last_synchronized= calendar_events_last_synchronized=).each do |method|
  	define_method(method) do |value|
  		match = /\A(?<data_type>\w+)_last_synchronized=\Z/.match(method)

  		self.last_synchronizeds[match[:data_type]] = value
  	end
  end

  private

  def prepare_last_synchronizeds_attribute
  	self.last_synchronizeds = { 'contacts' => nil, 'calls' => nil, 'text_messages' => nil, 'calendar_events' => nil }
  end
end