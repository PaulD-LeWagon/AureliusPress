class AureliusPress::Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = AureliusPress::User.all
  end

  def show
  end

  def new
    @user = AureliusPress::User.new
  end

  def create
    @user = AureliusPress::User.new(user_params)
    if @user.save
      redirect_to aurelius_press_admin_user_path(@user), notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to aurelius_press_admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to aurelius_press_admin_users_path, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = AureliusPress::User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to aurelius_press_admin_users_path, alert: 'User not found.'
  end

  def user_params
    params.require(:aurelius_press_user).permit(
      :email,
      :first_name,
      :last_name,
      :username,
      :password,
      :password_confirmation,
      :status,
      :role,
      :bio,
      :avatar,
      # group_ids: [],
      # aurelius_press_community_group_memberships_attributes: [:id, :group_id, :_destroy]
    )
  end
end
