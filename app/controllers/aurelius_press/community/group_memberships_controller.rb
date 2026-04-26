class AureliusPress::Community::GroupMembershipsController < AureliusPress::ApplicationController
  before_action :set_membership, only: %i[destroy]

  def create
    @group = AureliusPress::Community::Group.find(params[:group_membership][:group_id])
    @membership = @group.group_memberships.build(user: current_user, role: :member, status: :active)
    authorize @membership, :create?, policy_class: AureliusPress::Community::GroupMembershipPolicy

    if @membership.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "You joined the group." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
        format.html { redirect_back fallback_location: root_path, alert: @membership.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    authorize @membership, :destroy?, policy_class: AureliusPress::Community::GroupMembershipPolicy
    @group = @membership.group
    @membership.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path, notice: "You left the group." }
    end
  end

  private

  def set_membership
    @membership = AureliusPress::Community::GroupMembership.find(params[:id])
  end
end
