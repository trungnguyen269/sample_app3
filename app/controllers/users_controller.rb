class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :load_user, except: %i(new index create)
  def show
    return @user if @user = User.find_by(id: params[:id])
    flash[:danger] = I18n.t "user_not_found"
    redirect_to root_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    flash[:success] = @user.destroy ? t("user_deleted") : t("delete_failed")
    redirect_to users_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = I18n.t "static_pages.home.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "update_successful"
      redirect_to @user
    else
      render :edit
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "require_login"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash.now[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
