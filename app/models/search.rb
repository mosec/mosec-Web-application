class Search
	PER_PAGE = 10

	def self.search(params)
		Tire.search([:contacts, :text_messages, :calendar_events], load: true) do |search|
			search.query { string params[:query], default_operator: 'AND' } if params[:query].present?

			page = (params[:page] || 1).to_i

			search.from (page - 1) * PER_PAGE
			search.size PER_PAGE
		end
	end
end