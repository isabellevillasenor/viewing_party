class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash.now[:alert] = 'Invalid Email or Password'
      render :new
    end
  end

  def delete
    session.delete(:user_id)
    flash[:notice] = 'Successfully logged out'
    redirect_to root_path
  end
end
