class User
  include Mongoid::Document
  field :name,:type=>String
  EMAIL_FORMAT = {"link"=>"link","content"=> "content"}
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:name
  embeds_many :user_feeds
  references_and_referenced_in_many :feeds

#  def add_feed_ids_as_array
#    self.feed_ids = []
#  end
#
#
#  #references_and_referenced_in_many :user_feeds
#  def show_feeds
#    user_feeds = []
#    self.feed_ids.each do |feed|
#      user_feeds << Feed.find(feed.keys.first)
#    end
#    user_feeds
#  end
#  def show_feed_with_status
#    user_feeds = []
#
#    self.feed_ids.each do |feed|
#      user_feeds << [Feed.find(feed.keys.first),feed.values.first]
#    end
#    user_feeds
#  end
#
#
#
##Feed can be added in follwing ways
##  user.user_feeds= "Feedurl"
##  user.user_feeds= {:feed_url=>"Feedurl"}
##  user.user_feeds= Feed.first
##  user.user_feeds= [feedurl1,feedurl2]
##  user.user_feeds= [Feed.first,Feed.last]
#  def user_feeds(user_feeds=nil)
#    return show_feed_with_status if user_feeds.nil?
#    if user_feeds.is_a?(Array)
#      user_feeds.each do |feed|
#        add_feed(feed)
#      end
#    else
#      add_feed(user_feeds)
#    end
#  end
#
#  def add_feed(feed)
#    feed_url= ""
#
#    if feed.is_a?(Hash)
#      feed_url = feed[:feed_url] || feed["feed_url"]
#      new_feed = Feed.new(:feed_url=>feed_url)
#    else
#      if feed.is_a?(Feed)
#        feed_url = feed.feed_url
#        new_feed = feed
#      elsif feed.is_a?(String)
#        feed_url = feed
#        new_feed = Feed.new(:feed_url=>feed_url)
#      end
#    end
#
#    feed_obj =Feed.find(:first,:conditions=>{"feed_url"=>feed_url})
#    if feed_obj.blank?
#      if !feed_url.blank?
#        if new_feed.save!
#          self.feed_ids<<{new_feed._id.to_s=>EMAIL_FORMAT["content"]}
#          new_feed.user_ids << self._id if !new_feed.user_ids.include?(self._id)
#          new_feed.save
#        end
#      else
#        puts "Please ensure feed url is present"
#      end
#    else
#      self.feed_ids<<{feed_obj._id.to_s=>EMAIL_FORMAT["content"]}
#      feed_obj.user_ids << self._id if !feed_obj.user_ids.include?(self._id)
#    end
#    self.save!
#  end
#
#  def remove_feed(feed)
#
#    if !feed.blank?
#
#      self.feed_ids.each_with_index do |f,index|
#        if f.keys.first == feed._id.to_s
#          self.feed_ids.delete_at(index)
#          feed.user_ids.delete(self._id) if feed.user_ids.include?(self._id)
#          feed.save
#          feed.destroy if feed.user_ids.blank?
#        end
#      end
#      self.save
#
#      self.feed_ids.compact
#    end
#  end
end
