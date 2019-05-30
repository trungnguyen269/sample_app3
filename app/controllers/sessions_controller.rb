class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      remember_check params[:session][:remember_me], user
      redirect_back_or user
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

  def remember_check checked, user
    checked == Settings.checked ? remember(user) : forget(user)
  end

  def check_active_user user
    if user.activated?
      log_in user
      remember_check params[:session][:remember_me], user
      redirect_back_or user
    else
      flash[:warning] = t("account_inactivated")
      redirect_to root_path
    end
  end
end
