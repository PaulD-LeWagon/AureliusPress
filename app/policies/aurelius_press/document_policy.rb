class AureliusPress::DocumentPolicy < ::ApplicationPolicy
  def index?
    # All authenticated users can see the index page
    user.present?
  end

  # def show?
  #   if record.published?
  #     # Public documents are visible to everyone
  #     return true if record.visibility == "public_to_www"
  #     # Users and Readers can see documents with app or public visibility
  #     if user.user? || user.reader?
  #       return true if record.visibility.in?(["public_to_app_users", "public_to_www"])
  #     end
  #     # Users can see documents in their groups
  #     return true if user.user? && record.visibility == "private_to_group" && user.groups.include?(record.group)
  #   end
  #   # Superusers, Admins, and Moderators have blanket access
  #   return true if user.superuser? || user.admin? || user.moderator?
  #   # Owners can always see their own documents
  #   return true if record.user == user
  #   # Otherwise, access is denied
  #   false
  # end

  def show?
    # Superusers, Admins, and Mods can see everything regardless of status or visibility
    return true if user.superuser? || user.admin? || user.moderator?
    # Owners can always see their own documents, regardless of status or visibility
    return true if record.user == user
    # All other conditions must check for a published status
    return false unless record.published?
    # Public documents are visible to everyone
    return true if record.visibility == "public_to_www"
    # Users and Readers can see documents with app-level visibility
    if user.user? || user.reader?
      return true if record.visibility == "public_to_app_users"
    end
    # Users can see documents in their groups
    return true if user.user? && record.visibility == "private_to_group" && user.groups.include?(record.group)
    # All other cases are false by default
    false
  end

  def new?
    can_create_record?
  end

  def create?
    can_create_record?
  end

  def edit?
    power_user? || record_owner?
  end

  def update?
    power_user? || record_owner?
  end

  def destroy?
    power_user? || record_owner?
  end

  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  class Scope < ApplicationPolicy::Scope
    def resolve
      case
      when user.superuser? || user.admin? || user.moderator?
        # Admins and Mods can see everything
        scope.all
      when user.user?
        # Start with their own documents
        own_docs = scope.where(user: user)
        # Build conditions for other accessible documents
        accessible_docs_conditions = scope.where(visibility: ["public_to_app_users", "public_to_www"], status: :published)
        group_docs = scope.joins(:groups).where(groups: { id: user.groups.pluck(:id) }, status: :published)
        # Combine the scopes
        own_docs.or(accessible_docs_conditions).or(group_docs)
      when user.reader?
        # Reader sees published documents that are app-public or public-to-www
        scope.where(visibility: ["public_to_app_users", "public_to_www"], status: :published)
      else
        # Guest or nil user only sees published public-to-www documents
        scope.where(visibility: "public_to_www", status: :published)
      end
    end
  end

  # class Scope < ApplicationPolicy::Scope
  #   def resolve
  #     if user.superuser? || user.admin? || user.moderator?
  #       # Admins and Mods can see everything
  #       scope.all
  #     elsif user.user?
  #       # A user sees their own docs (any status)
  #       own_docs = scope.where(user: user)
  #       # Plus, app-public, public-to-web, and their group's docs (only if published)
  #       other_docs = scope.where(visibility: ["public_to_app_users", "public_to_www"], published: true).or(scope.joins(:groups).where(groups: { id: user.groups.pluck(:id) }, published: true))
  #       # Combine own docs with other accessible docs?
  #       own_docs.or(other_docs)
  #     elsif user.reader?
  #       # A reader only sees app-public and public-to-web docs
  #       scope.where(visibility: ["public_to_app_users", "public_to_www"], published: true)
  #     else
  #       # Guest or nil user only sees public-to-web docs
  #       scope.where(visibility: "public_to_www", published: true)
  #     end
  #   end
  # end

  private

  def record_owner?
    record.user_id == user.id
  end

  def power_user?
    user.superuser? || user.admin? || user.moderator?
  end

  def can_create_record?
    user.present? && (user.user? || power_user?)
  end
end
