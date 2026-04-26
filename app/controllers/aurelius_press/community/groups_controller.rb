class AureliusPress::Community::GroupsController < AureliusPress::ApplicationController
  before_action :set_group, only: %i[show]

  def index
    authorize AureliusPress::Community::Group, :index?, policy_class: AureliusPress::Community::GroupPolicy
    @groups = AureliusPress::Community::Group.where(privacy_setting: :public_group).order(:name)
  end

  def show
    authorize @group, :show?, policy_class: AureliusPress::Community::GroupPolicy
    @members = @group.members
    @membership = @group.group_memberships.find_by(user: current_user)
  end

  private

  def set_group
    @group = AureliusPress::Community::Group.find_by!(slug: params[:slug])
  end
end
