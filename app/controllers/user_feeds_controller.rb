class UserFeedsController < ApplicationController

  def index
    @user_feeds = current_user.user_feeds.paginate(:page=>params[:page],:per_page=>10)
    @user_feed = UserFeed.new
  end


  def create
    @user_feed = current_user.user_feeds.new(params[:user_feed])
    feed =  Feed.find_or_create_by_feed_url(params[:user_feed][:feed_url])
    @user_feed.feed = feed
    current_user.feeds << feed
    respond_to do |format|
      if @user_feed.save
        format.html { redirect_to(user_feeds_path, :notice => 'Feed was successfully created.') }
      else
        format.html { redirect_to(user_feeds_path, :notice => 'Feed was not successfully created.') }
      end
    end
  end





  def destroy
    @user_feed= current_user.user_feeds.find(params[:id])
    @feed = @user_feed.feed
    @user_feed.destroy
    @feed.users.delete(current_user)  if @feed.users.include?(current_user)
    current_user.feeds.delete(@feed)
    @feed.save!
    #Try to remove empty feed users
    #@feed.destroy if @feed.users.blank?
    current_user.save!

    redirect_to user_feeds_path
  end

  def show
    @user_feed= current_user.user_feeds.find(params[:id])
    @feed = @user_feed.feed
    @feed_items = @feed.feed_items.order_by(:published.desc).paginate(:page=>params[:page],:per_page=>10)

  end

end
