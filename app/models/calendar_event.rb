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
    indexes :user_id, type: :integer, index: :not_analyzed, include_in_all: false, as: Proc.new { user_id }
    indexes :contact_ids, type: :integer, index: :not_analyzed, include_in_all: false, as: Proc.new { contact_ids }
    indexes :title, type: :string
    indexes :description, type: :string
    indexes :location, type: :string
    indexes :attendee_email_addresses, type: :string, include_in_all: false
    indexes :start_time, type: :date, include_in_all: false
    indexes :end_time, type: :date, include_in_all: false
    indexes :all_day, type: :boolean, include_in_all: false
  end

  def user_id
    self.eventable.user.id
  end

  def contact_ids
    self.eventable.user.contacts.includes(:email_addresses).where(:email_addresses => { :email_address => self.attendee_email_addresses }).collect {|contact| contact.id }
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
