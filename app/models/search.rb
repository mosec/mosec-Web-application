class Search
	PER_PAGE = 10

	def self.search(user_id, params)
		Tire.search([:contacts, :calls, :text_messages, :calendar_events]) do |search|
			user = User.find(user_id)

			search.filter :term, :user_id => user.id

			search.filter(:term, :contact_ids => params[:contact_id]) if (params[:contact_id].present? and user.contacts.find(params[:contact_id]))

			search.query { string params[:query], default_operator: 'AND' } if params[:query].present?

			search.sort { by :time, 'desc' } if params[:query].blank?

			page = (params[:page] || 1).to_i

			search.from (page - 1) * PER_PAGE
			search.size PER_PAGE
		end
	end
end