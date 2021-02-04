class FriendshipsController < ApplicationController
  def update
    Friendship.find(params[:id]).update(status: 1)
    redirect_to dashboard_path
  end

  def destroy
    Friendship.find(params[:id]).destroy
    redirect_to dashboard_path
  end
end
