class AureliusPress::Admin::SiteSettingPolicy < AureliusPress::Admin::ApplicationPolicy
  def index?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end
end
