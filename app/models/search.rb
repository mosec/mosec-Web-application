class Search
	PER_PAGE = 10

	def self.search(user_id, params)
		indexes_to_search = []

		# if there is a query and the scope is global, search contacts, calls, text messages, and calendar events
		# else if there is no query or the scope is contact, show just calls, text messages, and calendar events
		if params[:query].present? and !params[:contact_id].present?
			indexes_to_search += [:contacts, :calls, :text_messages, :calendar_events]
		else
			# if there is no query, technically contacts won't be included anyways since there will be a sort on the data by time, but because there is no time associated with contacts, they'll be left out
			indexes_to_search += [:calls, :text_messages, :calendar_events]
		end

		Tire.search([:contacts, :calls, :text_messages, :calendar_events]) do |search|
			user = User.find(user_id)

			user_id_filter = { user_id: user.id }

			contact_ids_filter = { contact_ids: params[:contact_id] }
			contact_ids_filter_ok = params[:contact_id].present? and user.contacts.find(params[:contact_id])

			search.filter :term, user_id_filter

			# if the scope is contact and the contact belongs to the user (to prevent a user from searching other peoples' contacts' data), search just the contact's data
			search.filter(:term, contact_ids_filter) if contact_ids_filter_ok

			search.filter(:term, { _type: params[:data_type] }) if params[:data_type].present?

			# if there is a query, use it to search
			search.query { text :_all, params[:query] } if params[:query].present?

			# if there is no query, sort by time
			# else by default, sort by relevance
			search.sort { by :time, 'desc' } if params[:query].blank?

			search.facet(:data_types, { facet_filter: { term: contact_ids_filter_ok ? user_id_filter.merge(contact_ids_filter) : user_id_filter } }) do
				terms :_type
			end

			page = (params[:page] || 1).to_i

			search.from (page - 1) * PER_PAGE
			search.size PER_PAGE
		end
	end
end