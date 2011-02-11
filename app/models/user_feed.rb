class UserFeed
  include Mongoid::Document
  field :status,:default=>'content'
  field :feed_url
  field :sanitize,:type=>Boolean,:default=>false
  validates_presence_of :feed_url
  validates_uniqueness_of :feed_url
  EMAIL_STATUS = {'content'=>'content','link'=>'link'}
  embedded_in :user,:inverse_of=>:user_feeds
  referenced_in :feed
  attr_accessible :status,:feed_url
  #before_create :add_into_feed_if_not_exist

  def add_into_feed_if_not_exist
    feed = Feed.find(:first,:conditions=>{"feed_url"=>self.feed_url})
    Feed.create!(:feed_url=>self.feed_url) if feed.blank?
  end
end
