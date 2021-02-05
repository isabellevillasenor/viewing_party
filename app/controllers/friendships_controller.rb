class FriendshipsController < ApplicationController
  def create
    friend = User.find_by(email: params[:email])
    if friend && current_user.all_friends.exclude?(friend)
      Friendship.create(user: current_user, friend: friend)
      flash[:notice] = 'Friend request sent!'
    else
      flash[:alert] = "Unable to locate user #{params[:email]}"
    end
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
