class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow @user
    respond_user_path
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow @user
    respond_user_path
  end

  private

  def respond_user_path
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "micropost.nil"
    redirect_to root_path
  end

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]
    return if @relationship

    flash[:danger] = t "micropost.nil"
    redirect_to root_path
  end
end
