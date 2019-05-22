class UsersController < ApplicationController
  def show
    return @user if @user = User.find_by(id: params[:id])
    flash[:danger] = I18n.t "user_not_found"
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = I18n.t "static_pages.home.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
end
