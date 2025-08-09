class AureliusPress::Admin::UserPolicy < ::ApplicationPolicy
  attr_reader :params

  def initialize(user, record, params)
    super(user, record)
    @params = params
  end

  def admin_access?
    admin_or_greater_role_check
  end

  def index?
    admin_or_greater_role_check
  end

  def show?
    admin_or_greater_role_check && can_update_record?
  end

  def new?
    admin_or_greater_role_check
  end

  def create?
    admin_or_greater_role_check
  end

  def edit?
    admin_or_greater_role_check && can_update_record?
  end

  def update?
    # Admins can edit readers, users and moderators, but not other admins or superusers.
    admin_or_greater_role_check && can_update_record? && can_change_role?
  end

  def destroy?
    # Admins can destroy users and moderators, but not other admins or superusers.
    admin_or_greater_role_check && can_update_record?
  end

  # This scope class handles the collection of records.
  class Scope < Scope
    def resolve
      # If the user is an admin or superuser, we filter the list of users.
      if AureliusPress::User.roles[user.role] >= AureliusPress::User.roles[:admin]
        # Exclude other admins and superusers
        scope.where.not(role: [:admin, :superuser])
      else
        # For moderators and below, they see no users at all.
        scope.none
      end
    end
  end

  private

  def admin_or_greater_role_check
    # Check if the user's role is at least 'admin'
    # The enum's ascending order allows for this easy check.
    AureliusPress::User.roles[user.role] >= AureliusPress::User.roles[:admin]
  end

  def can_update_record?
    can_manage_role?(record.role)
  end

  def can_change_role?
    user_params = params.fetch(:aurelius_press_user, {})
    new_role = user_params.key?(:role) ? user_params[:role] : ''

    # If no role is being changed, it's allowed.
    return true if new_role.blank? || new_role == record.role.to_s

    can_manage_role?(new_role)
  end

  def can_manage_role?(target_role)
    AureliusPress::User.roles[user.role] > AureliusPress::User.roles[target_role]
  end
end
