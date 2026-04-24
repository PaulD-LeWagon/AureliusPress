class AureliusPress::Catalogue::SourcePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin_or_above?
  end

  def update?
    admin_or_above?
  end

  def destroy?
    admin_or_above?
  end

  private

  def admin_or_above?
    user.present? && (user.admin? || user.superuser?)
  end
end
