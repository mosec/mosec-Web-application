class SynchronizePhoneContacts
  @queue = :synchronize_phone_contacts
  
  def self.perform(user_id, phone_id, contacts_to_index_json_string)
    user = User.find(user_id)
    phone = user.phones.find(phone_id)
    
    contacts_to_index = JSON.parse(contacts_to_index_json_string)
    
    contacts_to_index_uids = contacts_to_index.collect {|contact_to_index_attributes| contact_to_index_attributes['uid'] }
    
    phone.contacts.where('uid NOT IN (?)', contacts_to_index_uids).map(&:destroy)
    
    contacts_to_index.each do |contact_to_index_attributes|
      clean_contact_to_index_attributes = contact_to_index_attributes.except('phone_numbers', 'email_addresses')
      phone_numbers_to_index = contact_to_index_attributes['phone_numbers']
      email_addresses_to_index = contact_to_index_attributes['email_addresses']
      
      existing_contact = phone.contacts.where(:uid => clean_contact_to_index_attributes['uid']).first
      
      if existing_contact
        clean_existing_contact_to_index_attributes = clean_contact_to_index_attributes.except('uid')
        
        existing_contact.update_attributes!(clean_existing_contact_to_index_attributes)
        
        existing_contact.remove_phone_numbers_not_in_list!(phone_numbers_to_index)
        
        existing_contact.add_phone_numbers!(phone_numbers_to_index)
        
        existing_contact.remove_email_addresses_not_in_list!(email_addresses_to_index)
        
        existing_contact.add_email_addresses!(email_addresses_to_index)
      else
        contact = phone.contacts.create!(clean_contact_to_index_attributes)
        
        contact.add_phone_numbers!(phone_numbers_to_index)
        
        contact.add_email_addresses!(email_addresses_to_index)
      end
    end
  end

  def self.after_perform(user_id, phone_id, contacts_to_index_json_string)
    set_phone_contacts_last_synchronized(user_id, phone_id, DateTime.now)

    queue_update_index(user_id)
  end

  def self.set_phone_contacts_last_synchronized(user_id, phone_id, time)
    user = User.find(user_id)
    phone = user.phones.find(phone_id)

    phone.contacts_last_synchronized = DateTime.now

    phone.save
  end

  def self.queue_update_index(user_id)
    user = User.find(user_id)

    Resque.enqueue(UpdateIndex, user.id, 'call')
    Resque.enqueue(UpdateIndex, user.id, 'text_message')
    Resque.enqueue(UpdateIndex, user.id, 'calendar_event')
  end
end