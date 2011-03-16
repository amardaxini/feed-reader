class FeedJob
	@queue = :feed_serve
	def self.perform(feeds="")
    Feed.update_feeds(feeds)
  end
end
