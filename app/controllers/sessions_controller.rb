class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      remember_check params[:session][:remember_me], user
      redirect_to user
    else
      flash.now[:danger] = t "invalid_user"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
  private
  def login_redirect user
    log_in user
    params[:session][:remember_me] == Settings.checked ? remember(user) : forget(user)
    redirect_to user
  end
end
