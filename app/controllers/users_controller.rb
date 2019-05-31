class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :load_user, except: %i(new index create)
  def show
    redirect_to root_url && return unless @user.activated
    @microposts = @user.microposts.paginate page: params[:page],
    per_page: Settings.index_per_page
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
      @user.send_activation_email
      flash[:info] = t "check_email_announce"
      redirect_to root_url
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

  def following
    @title = t "following"
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t "followers"
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
  end
  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
