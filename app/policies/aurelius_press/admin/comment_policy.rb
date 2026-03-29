class AureliusPress::Admin::CommentPolicy < AureliusPress::Admin::ApplicationPolicy
  def index?
    moderator?
  end

  def show?
    moderator?
  end

  def destroy?
    moderator?
  end

  class Scope < Scope
    def resolve
      if user.moderator? || user.admin? || user.superuser?
        scope.all
      else
        scope.none
      end
    end
  end
end
