class AureliusPress::Admin::ApplicationPolicy < ::ApplicationPolicy
  def admin?
    user.admin? || user.superuser?
  end

  def moderator?
    user.moderator? || admin?
  end

  def admin_access?
    # Check if the user's role is at least 'moderator'
    # The enum's ascending order allows for this easy check.
    AureliusPress::User.roles[user.role] >= AureliusPress::User.roles[:moderator]
  end
end
