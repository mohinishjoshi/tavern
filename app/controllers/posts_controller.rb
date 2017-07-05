class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, :except => [:create]

  def edit
  end

  def create
    post = current_user.posts.build(post_params)

    if post.save
      redirect_to root_path, :notice => "And its out there"
    end
  end

  def destroy
    if current_user.is_owner?(@post)
      @post.delete
      redirect_to root_path, :notice => "Successfully deleted post"
    else
      redirect_to root_path, :error => "Could not delete post"
    end
  end

  def update
    if current_user.is_owner?(@post) && @post.update(post_params)
      redirect_to root_path, :notice => "Post saved"
    else
      redirect_to root_path, :error => "Could not update post"
    end
  end

  private

  def post_params
    params.require(:post).permit(:message, :picture)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end
