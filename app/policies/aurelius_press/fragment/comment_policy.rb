class AureliusPress::Fragment::CommentPolicy < ApplicationPolicy
  def index?
    # Public index might be filtered by visibility in a scope
    true
  end

  def show?
    # Users can see a comment if they can see the commentable object.
    # For now, we assume if they can reach the commentable, they can see comments.
    true
  end

  def create?
    # All authenticated users can create comments
    user.present?
  end

  def update?
    # Users can only update their own comments
    user.present? && record.user_id == user.id
  end

  def destroy?
    # Users can only delete their own comments
    user.present? && record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      # In a real app, this would filter by visibility of the parent object.
      scope.all
    end
  end
end
