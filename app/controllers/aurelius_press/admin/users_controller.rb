class AureliusPress::Admin::UsersController < AureliusPress::Admin::ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    # The policy scope will filter the users based on the current user's role.
    authorize AureliusPress::User, :index?, policy_class: AureliusPress::Admin::UserPolicy
    @users = policy_scope(AureliusPress::User, policy_scope_class: AureliusPress::Admin::UserPolicy::Scope).order(role: :desc, last_name: :asc, first_name: :asc)
  end

  def show
    # The @user is already set by the before_action
    authorize @user, :show?, policy_class: AureliusPress::Admin::UserPolicy
  end

  def new
    @user = AureliusPress::User.new
    authorize @user, :new?, policy_class: AureliusPress::Admin::UserPolicy
  end

  def create
    @user = AureliusPress::User.new(user_params)
    authorize @user, :create?, policy_class: AureliusPress::Admin::UserPolicy
    if @user.save
      redirect_to aurelius_press_admin_user_path(@user), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # The @user is already set by the before_action
    authorize @user, :edit?, policy_class: AureliusPress::Admin::UserPolicy
  end

  def update
    # The @user is already set by the before_action
    authorize @user, :update?, policy_class: AureliusPress::Admin::UserPolicy
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
    authorize @user, :destroy?, policy_class: AureliusPress::Admin::UserPolicy
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
      :age,
      # group_ids: [],
      # aurelius_press_community_group_memberships_attributes: [:id, :group_id, :_destroy]
    )
  end
end
