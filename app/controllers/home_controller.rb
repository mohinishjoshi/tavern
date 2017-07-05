class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @post = Post.new
    @posts = current_user.get_feed.reverse
  end
end
