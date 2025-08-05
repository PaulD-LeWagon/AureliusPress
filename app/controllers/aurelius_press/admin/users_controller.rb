class AureliusPress::Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = AureliusPress::User.all
  end

  def show
    # The @user is already set by the before_action
  end

  def new
    @user = AureliusPress::User.new
  end

  def create
    @user = AureliusPress::User.new(user_params)
    if @user.save
      redirect_to aurelius_press_admin_user_path(@user), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # The @user is already set by the before_action
  end

  def update
    # The @user is already set by the before_action
    # If password and *confirmation is empty remove it from the params to avoid validation errors
    params_without_password = user_params
    if params_without_password[:password].blank? && params_without_password[:password_confirmation].blank?
      params_without_password.delete(:password)
      params_without_password.delete(:password_confirmation)
    end
    if @user.update(params_without_password)
      redirect_to aurelius_press_admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # The @user is already set by the before_action
    @user.destroy!
    redirect_to aurelius_press_admin_users_path, notice: "User was successfully destroyed."
  end

  private

  def set_user
    @user = AureliusPress::User.find(params[:id])
  end

  def user_params
    params.require(:aurelius_press_user).permit(
      :id,
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
