class Search
	PER_PAGE = 10

	def self.search(user_id, params)
		Tire.search([:contacts, :text_messages, :calendar_events], load: true) do |search|
			search.query do
				boolean do
					must { term :user_id, user_id }
					must { text :_all, params[:query] } if params[:query].present?
				end
			end

			page = (params[:page] || 1).to_i

			search.from (page - 1) * PER_PAGE
			search.size PER_PAGE
		end
	end
end