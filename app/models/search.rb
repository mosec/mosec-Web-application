class Search
	PER_PAGE = 10

	def self.search(user_id, params)
		Tire.search([:contacts, :text_messages, :calendar_events], load: true) do |search|
			search.filter :term, :user_id => user_id
			search.filter(:term, :contact_ids => params[:contact_id]) if params[:contact_id].present?

			search.query do
				boolean do
					must { text :_all, params[:query] } if params[:query].present?
				end
			end

			search.facet :contacts do
				terms :contact_id
			end

			page = (params[:page] || 1).to_i

			search.from (page - 1) * PER_PAGE
			search.size PER_PAGE
		end
	end
end