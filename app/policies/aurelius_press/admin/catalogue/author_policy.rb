class AureliusPress::Admin::Catalogue::AuthorPolicy < AureliusPress::Admin::ApplicationPolicy
  attr_reader :params

  def initialize(user, record, params = {})
    super(user, record)
    @params = params
  end

  def index?
    admin_or_greater_role_check
  end

  def show?
    admin_or_greater_role_check
  end

  def new?
    admin_or_greater_role_check
  end

  def create?
    admin_or_greater_role_check
  end

  def edit?
    admin_or_greater_role_check
  end

  def update?
    admin_or_greater_role_check
  end

  def destroy?
    admin_or_greater_role_check
  end

  # This scope class handles the collection of records.
  class Scope < Scope
    def resolve
      if user.admin? || user.superuser?
        scope.all
      else
        scope.none
      end
    end
  end

  def admin_access?
    admin_or_greater_role_check
  end

  private

  def admin_or_greater_role_check
    # Check if the user's role is at least 'admin'
    # The enum's ascending order allows for this easy check.
    AureliusPress::User.roles[user.role] >= AureliusPress::User.roles[:admin]
  end
end
