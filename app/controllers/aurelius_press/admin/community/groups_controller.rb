class AureliusPress::Admin::Community::GroupsController < AureliusPress::Admin::ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = AureliusPress::Community::Group.all
  end

  def show
    if @group.nil?
      redirect_to aurelius_press_admin_community_groups_path, alert: "Group not found."
    end
  end

  def new
    @group = AureliusPress::Community::Group.new
  end

  def create
    @group = AureliusPress::Community::Group.new(group_params)
    if @group.save
      redirect_to aurelius_press_admin_community_group_path(@group), notice: "Group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if @group.nil?
      redirect_to aurelius_press_admin_community_groups_path, alert: "Group not found."
    end
  end

  def update
    if @group.update(group_params)
      redirect_to aurelius_press_admin_community_group_path(@group), notice: "Group was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to aurelius_press_admin_community_groups_path, notice: "Group was successfully destroyed."
  end

  private

  def set_group
    @group = AureliusPress::Community::Group.find(params[:id])
  end

  def group_params
    params.require(:aurelius_press_community_group).permit(
      :name,
      :description,
      :creator_id,
      :status,
      :privacy_setting,
      :image
    )
  end
end
