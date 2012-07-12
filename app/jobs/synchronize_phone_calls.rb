class SynchronizePhoneCalls
  @queue = :synchronize_phone_calls
  
  def self.perform(user_id, phone_id, calls_to_index_json_string)
    user = User.find(user_id)
    phone = user.phones.find(phone_id)
    
    calls_to_index = JSON.parse(calls_to_index_json_string)
    
    calls_to_index.each do |call_to_index_attributes|
      existing_call = phone.calls.where(uid: call_to_index_attributes['uid']).first
      
      unless existing_call
        phone.calls.create(call_to_index_attributes)
      end
    end
  end

  def self.after_perform(user_id, phone_id, calls_to_index_json_string)
    user = User.find(user_id)
    phone = user.phones.find(phone_id)

    phone.calls_last_synchronized = DateTime.now

    phone.save
  end
end