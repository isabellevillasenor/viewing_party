class FriendshipsController < ApplicationController
  def create
    current_user.add_friend(params[:email]) || flash[:alert] = "Unable to locate user #{params[:email]}"
    redirect_to dashboard_path
  end

  def update
    Friendship.find(params[:id]).update(status: 1)
    redirect_to dashboard_path
  end

  def destroy
    Friendship.find(params[:id]).destroy
    redirect_to dashboard_path
  end
end
