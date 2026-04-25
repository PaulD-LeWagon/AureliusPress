class AureliusPress::Community::LikePolicy < ApplicationPolicy
  def create?
    can_write?
  end

  def update?
    power_user? || record_owner?
  end

  def destroy?
    power_user? || record_owner?
  end

  private

  def can_write?
    user.present? && (user.user? || power_user?)
  end

  def record_owner?
    user.present? && record.user_id == user.id
  end

  def power_user?
    user.present? && (user.superuser? || user.admin? || user.moderator?)
  end
end
