require 'feedzirra'
class Feed
  include Mongoid::Document
#  attr_accessible :url, :title,:feed_url,:etag,:user_status,:last_modified
#  attr_protected :_id
  field :url
  field :title
  field :feed_url
  field :etag
  field :last_modified,:type=>DateTime
  validates_presence_of :feed_url
  validates_uniqueness_of :feed_url
  references_and_referenced_in_many :users
  embeds_many :feed_items

  def self.find_or_create_by_feed_url(feed_url)
    Feed.find_or_create_by(:feed_url=>feed_url)
  end

  after_create :add_feed_items

  def add_feed_items
    feed =Feedzirra::Feed.fetch_and_parse(self.feed_url,
                                          :on_success => Proc.new do |url,feed|
                                            self.update_attributes(:title=>feed.title,:etag=>feed.etag,:last_modified=>feed.last_modified,:url=>feed.url)
                                            feed.sanitize_entries!
                                            feed.entries.each do |feed_item|
                                              self.feed_items.create!(:url=>feed_item.url,:title=>feed_item.title,:author=>feed_item.author,:summary=>feed_item.summary,:content=>feed_item.content,:published=>feed_item.published,:categories=>feed_item.categories)
                                            end
                                          end,
                                          :on_failure => lambda {|url, response_code, response_header, response_body| puts response_body })
#    if feed == 0
#      self.destroy
#    end
  end
#
  def self.update_feeds(feeds=nil)
    if feeds.blank?
      feeds = Feed.all.collect{|f| unless f.users.blank?;f.feed_url;end}.flatten.compact
    end
    update_feed = Feedzirra::Feed.fetch_and_parse(feeds,
                                                  :on_success => Proc.new do |url,feed|
                                                    feed_obj = Feed.find(:first,:conditions=>{:feed_url=>url})
                                                    if feed_obj.etag.blank?
                                                      if feed.etag!= feed_obj.etag || feed.last_modified > feed_obj.last_modified
                                                        self.update_attributes(:title=>feed.title,:etag=>feed.etag,:last_modified=>feed.last_modified,:url=>feed.url)
                                                        feed_items_obj = feed_obj.feed_items
                                                        feed.sanitize_entries!
                                                        feed.entries.each do |feed_item|
                                                          if !feed_items.find(:first,:conditions=>{:url=>feed_item.url})
                                                            self.feed_items.create!(:url=>feed_item.url,:title=>feed_item.title,:author=>feed_item.author,:summary=>feed_item.summary,:content=>feed_item.content,:published=>feed_item.published,:categories=>feed_item.categories)
                                                          else
                                                            self.feed_items.update_attributes(:title=>feed_item.title,:author=>feed_item.author,:summary=>feed_item.summary,:content=>feed_item.content,:published=>feed_item.published,:categories=>feed_item.categories)
                                                          end
                                                        end
                                                      end
                                                    else
                                                      self.update_attributes(:title=>feed.title,:etag=>feed.etag,:last_modified=>feed.last_modified,:url=>feed.url)
                                                      feed.sanitize_entries!
                                                      feed.entries.each do |feed_item|
                                                        self.feed_items.create!(:url=>feed_item.url,:title=>feed_item.title,:author=>feed_item.author,:summary=>feed_item.summary,:content=>feed_item.content,:published=>feed_item.published,:categories=>feed_item.categories)
                                                      end
                                                    end
                                                  end,
                                                  :on_failure => lambda {|url, response_code, response_header, response_body| puts response_code })
  end
end
