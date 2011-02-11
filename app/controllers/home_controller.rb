class HomeController < ApplicationController
  skip_before_filter :authenticate_user!,:only=>[:index]
  def index
  end

  def manage_feeds
    respond_to do |format|
      format.html
    end
  end
end
