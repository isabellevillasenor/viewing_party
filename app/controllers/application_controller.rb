class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    return if current_user

    flash[:notice] = 'Please Log in or Create an Account'
    redirect_to root_path
  end
end
