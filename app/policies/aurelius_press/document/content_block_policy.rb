class AureliusPress::Document::ContentBlockPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    power_user? || document_owner?
  end

  def update?
    power_user? || document_owner?
  end

  def destroy?
    power_user? || document_owner?
  end

  private

  def document_owner?
    user.present? && record.document.user_id == user.id
  end

  def power_user?
    user.present? && (user.superuser? || user.admin? || user.moderator?)
  end
end
