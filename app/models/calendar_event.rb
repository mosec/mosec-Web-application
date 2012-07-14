class CalendarEvent < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Expect
  
  belongs_to :eventable, polymorphic: true
  
  attr_accessible :uid, :title, :description, :location, :attendee_email_addresses, :start_time, :end_time, :all_day
  
  validates :uid, presence: true, uniqueness: { scope: [:eventable_id, :eventable_type] }
  validates :title, presence: true
  validates :start_time, presence: true, numericality: true
  validates :end_time, presence: true, numericality: true
  validates :all_day, inclusion: { in: [true, false] }

  mapping do
    indexes :title
    indexes :description
    indexes :location
  end

  def attendee_email_addresses=(attendee_email_addresses)
    self[:attendee_email_addresses] = Expect.normalize_string_to_array(attendee_email_addresses)
  end

  def start_time=(time)
    self[:start_time] = Time.at(time).to_datetime
  end

  def end_time=(time)
    self[:end_time] = Time.at(time).to_datetime
  end
end
