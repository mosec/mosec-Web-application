class DestroySource
  @queue = :destroy_source

  def self.after_enqueue(user_id, source_id)
    user = User.find(user_id)
    source = user.sources.find(source_id)

    source.queued_for_destruction = true

    source.save
  end

	def self.perform(user_id, source_id)
		user = User.find(user_id)
		source = user.sources.find(source_id)

		source.destroy
	end
end