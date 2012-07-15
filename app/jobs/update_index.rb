class UpdateIndex
  include Expect

	@queue = :update_index

	def self.perform(user_id, index_class_to_update)
		user = User.find(user_id)

		case index_class_to_update
		when Expect.normalize_class_to_string(Call)
	    user.calls.each {|call| call.tire.update_index }
	  when Expect.normalize_class_to_string(TextMessage)
	    user.text_messages.each {|call| call.tire.update_index }
	  when Expect.normalize_class_to_string(CalendarEvent)
	    user.calendar_events.each {|call| call.tire.update_index }
	  end
	end
end