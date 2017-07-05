class SearchController < ApplicationController
  def search
    unless params[:query].blank?
      @users = User.where('first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ? OR address ILIKE ?', params[:query], params[:query], params[:query], params[:query])
    end
  end
end
