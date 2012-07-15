class Search
	PER_PAGE = 10

	def self.search(user_id, params)
		Tire.search([:contacts, :text_messages, :calendar_events], load: true) do |search|
			user = User.find(user_id)

			search.filter :term, :user_id => user.id

			# TODO: user.phones.first.contacts
			search.filter(:term, :contact_ids => params[:contact_id]) if (params[:contact_id].present? and user.phones.first.contacts.find(params[:contact_id]))

			search.query do
				boolean do
					must { fuzzy :_all, params[:query] } if params[:query].present?
				end
			end

			page = (params[:page] || 1).to_i

			search.from (page - 1) * PER_PAGE
			search.size PER_PAGE
		end
	end
end