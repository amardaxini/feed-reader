class FeedItem
   include Mongoid::Document
   field :title, :type=>String
   field :url, :type=>String
   field :author,:type=>String
   field :summary,:type=>String
   field :content,:type=>String
   field :published,:type=>DateTime
   field :categories,:type=>Array
   validates_uniqueness_of :url
   embedded_in :feed, :inverse_of => :feed_items
end
