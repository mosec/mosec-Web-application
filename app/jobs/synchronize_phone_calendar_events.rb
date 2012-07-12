class SynchronizePhoneCalendarEvents
  @queue = :synchronize_phone_calendar_events

  def self.perform(user_id, phone_id, calendar_events_to_index_json_string)
    user = User.find(user_id)
    phone = user.phones.find(phone_id)
    
    calendar_events_to_index = JSON.parse(calendar_events_to_index_json_string)
    
    calendar_events_to_index_uids = calendar_events_to_index.collect {|calendar_event_to_index_attributes| calendar_event_to_index_attributes['uid'] }
    
    phone.calendar_events.where('uid NOT IN (?)', calendar_events_to_index_uids).map(&:destroy)
    
    calendar_events_to_index.each do |calendar_event_to_index_attributes|
      existing_calendar_event = phone.calendar_events.where(:uid => calendar_event_to_index_attributes['uid']).first
      
      if existing_calendar_event
        clean_existing_calendar_event_to_index_attributes = calendar_event_to_index_attributes.except('uid')
        
        existing_calendar_event.update_attributes(clean_existing_calendar_event_to_index_attributes)
      else
        phone.calendar_events.create(calendar_event_to_index_attributes)
      end
    end
  end

  def self.after_perform(user_id, phone_id, calendar_events_to_index_json_string)
    user = User.find(user_id)
    phone = user.phones.find(phone_id)

    phone.calendar_events_last_synchronized = DateTime.now

    phone.save
  end
end