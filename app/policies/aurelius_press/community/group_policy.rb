class AureliusPress::Community::GroupPolicy < ApplicationPolicy
  def index?
    can_write?
  end

  def show?
    return true if power_user?
    return false unless user.present? && (user.user? || power_user?)
    return true if record.public_group?
    group_creator? || member_of_group?
  end

  def create?
    can_write?
  end

  def update?
    power_user? || group_creator?
  end

  def destroy?
    power_user? || group_creator?
  end

  private

  def can_write?
    user.present? && (user.user? || power_user?)
  end

  def group_creator?
    user.present? && record.creator_id == user.id
  end

  def member_of_group?
    user.present? && record.group_memberships.where(user: user, status: :active).exists?
  end

  def power_user?
    user.present? && (user.superuser? || user.admin? || user.moderator?)
  end
end
