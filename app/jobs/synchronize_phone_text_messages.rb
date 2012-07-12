class SynchronizePhoneTextMessages
  @queue = :synchronize_phone_text_messages
  
  def self.perform(user_id, phone_id, text_messages_to_index_json_string)
    user = User.find(user_id)
    phone = user.phones.find(phone_id)
    
    text_messages_to_index = JSON.parse(text_messages_to_index_json_string)
    
    text_messages_to_index.each do |text_message_to_index_attributes|
      existing_text_message = phone.text_messages.where(:uid => text_message_to_index_attributes['uid']).first
      
      unless existing_text_message
        phone.text_messages.create(text_message_to_index_attributes)
      end
    end
  end

  def self.after_perform(user_id, phone_id, text_messages_to_index_json_string)
    user = User.find(user_id)
    phone = user.phones.find(phone_id)

    phone.text_messages_last_synchronized = DateTime.now

    phone.save
  end
end