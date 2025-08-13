class AureliusPress::DocumentPolicy < ::ApplicationPolicy
  def index?
    # All authenticated users can see the index page
    user.present?
  end

  def show?
    # 1. Superusers and Admins can see everything regardless of status or visibility
    return true if user.superuser? || user.admin?
    # 2. Deny access to trashed documents for everybody else.
    return false if record.trashed?
    # 3. Moderators can see everything except trashed documents
    return true if user.moderator?
    # 4. Deny access to documents in_review to everybody else lower than a mdoerator.
    return false if record.in_review?
    # 5. Owners can always see their own documents, regardless of visibility and status (excluding trashed and in_review)
    return true if record.user == user
    # 6. Deny access to scheduled documents as only users and above should be able to view them.
    return false if record.scheduled?
    # 7. All other conditions must check for a published status
    return false unless record.published?
    # 8. Public documents are visible to everyone
    return true if record.visibility == "public_to_www"
    # 9. Users can see documents with app-level visibility and group membership
    if user.user?
      return true if record.public_to_app_users?
      return true if record.private_to_group? && user.groups.include?(record.group)
    end
    # 10. Readers can see published documents for app users.
    return true if user.reader? && record.public_to_app_users?
    # 11. All other cases are false by default
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
      when user.superuser? || user.admin?
        # Superusers and Admins can see everything
        scope.all
      when user.moderator?
        # Moderators can see everything except trashed documents
        scope.where.not(status: :trashed)
      when user.user?
        # Query 1: Get IDs of the user's own documents (any status)
        own_docs_ids = scope.where(user: user).where.not(status: [:in_review, :trashed]).pluck(:id)
        # Query 2: Get IDs of published, public documents
        public_docs_ids = scope.where(visibility: ["public_to_app_users", "public_to_www"], status: :published).pluck(:id)
        # Query 3: Get IDs of published documents for groups the user belongs to
        group_docs_ids = scope.joins(:groups).where(groups: { id: user.groups.pluck(:id) }, status: :published).pluck(:id)
        # Combine all the unique IDs and return the documents
        combined_ids = (own_docs_ids + public_docs_ids + group_docs_ids).uniq
        # Return the final scope
        scope.where(id: combined_ids)
      when user.reader?
        # Reader sees published documents that are app-public or public-to-www
        scope.where(visibility: ["public_to_app_users", "public_to_www"], status: :published)
      else
        # Guest or nil user only sees published public-to-www documents
        scope.where(visibility: "public_to_www", status: :published)
      end
    end
  end

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
