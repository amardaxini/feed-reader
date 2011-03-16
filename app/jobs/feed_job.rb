class FeedJob
	@queue = :feed_serve
	def self.perform(method_name,feeds="")
		if method_name == "add_feed_items"
			feed = Feed.find(feeds)
			feed.add_feed_items
		else
  		Feed.update_feeds(feeds)
		end
  end
end
