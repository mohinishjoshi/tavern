class UserController < ApplicationController
  before_action :authenticate_user!

  def show
    if !params[:id].blank? && is_integer?(params[:id])
      @user = User.find(params[:id])
    end
  end

  def toggle_friendship
    @user = User.find(params[:friend_id])
    return if @user.blank?
    if current_user.is_friend?(@user)
      current_user.remove_friend(@user)
      redirect_to user_path(@user), :notice => "You are not following #{@user.full_name} anymore."
    else
      current_user.add_friend(@user)
      redirect_to user_path(@user), :notice => "You are following #{@user.full_name} now."
    end
  end
end
