class AureliusPress::Admin::UserPolicy < AureliusPress::Admin::ApplicationPolicy
  attr_reader :params

  def initialize(user, record, params = {})
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
      # Handle superusers first, as they should see all users.
      # User scope.all to view all users including all superusers
      if user.superuser?
        # To exclude superusers from the list i.e.: superusers are ignorant of each other!
        scope.where.not(role: [:superuser])
        # Then handle admins, who should see everyone except other admins and superusers.
      elsif user.admin?
        scope.where.not(role: [:admin, :superuser])
      else
        # All other roles see no users.
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
    new_role = user_params.key?(:role) ? user_params[:role] : ""
    # If no role is being changed, it's allowed.
    return true if new_role.blank? || new_role == record.role.to_s
    can_manage_role?(new_role)
  end

  def can_manage_role?(target_role)
    target_role_sym = target_role.to_s.downcase.to_sym
    AureliusPress::User.roles[user.role] > AureliusPress::User.roles[target_role_sym]
  end
end
