class DashboardController < ApplicationController
  def index
    if params[:email]
      current_user.add_friend(params[:email]) || flash[:alert] = "Unable to locate user #{params[:email]}"
    end
    @friends = current_user.friends
  end
end
