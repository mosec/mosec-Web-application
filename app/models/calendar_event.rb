class CalendarEvent < ActiveRecord::Base
  include Expect
  
  belongs_to :eventable, polymorphic: true
  
  attr_accessible :uid, :title, :description, :location, :attendee_email_addresses, :start_time, :end_time, :all_day
  
  validates :uid, presence: true, uniqueness: { scope: [:eventable_id, :eventable_type] }
  validates :title, presence: true
  validates :start_time, presence: true, numericality: true
  validates :end_time, presence: true, numericality: true
  validates :all_day, inclusion: { in: [true, false] }
  
  def attendee_email_addresses=(attendee_email_addresses)
    self[:attendee_email_addresses] = Expect.normalize_string_to_array(attendee_email_addresses)
  end
end
