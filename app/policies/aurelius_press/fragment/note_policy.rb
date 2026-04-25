class AureliusPress::Fragment::NotePolicy < ApplicationPolicy
  def index?
    can_write?
  end

  def show?
    power_user? || record_owner?
  end

  def create?
    can_write?
  end

  def update?
    power_user? || record_owner?
  end

  def destroy?
    power_user? || record_owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if power_user?
        scope.all
      elsif user.present? && (user.user? || user.moderator? || user.admin? || user.superuser?)
        scope.where(user: user)
      else
        scope.none
      end
    end

    private

    def power_user?
      user.present? && (user.superuser? || user.admin? || user.moderator?)
    end
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
