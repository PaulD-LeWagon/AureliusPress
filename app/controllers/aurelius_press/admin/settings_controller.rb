class AureliusPress::Admin::SettingsController < AureliusPress::Admin::ApplicationController
  before_action :set_setting, only: %i[edit update]

  def index
    @settings = AureliusPress::SiteSetting.all.order(:key)
    authorize AureliusPress::SiteSetting, :index?, policy_class: AureliusPress::Admin::SiteSettingPolicy
  end

  def edit
    authorize @setting, :edit?, policy_class: AureliusPress::Admin::SiteSettingPolicy
  end

  def update
    authorize @setting, :update?, policy_class: AureliusPress::Admin::SiteSettingPolicy

    if @setting.update(setting_params)
      redirect_to aurelius_press_admin_settings_path, notice: "Setting updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_setting
    @setting = AureliusPress::SiteSetting.find(params[:id])
  end

  def setting_params
    params.require(:aurelius_press_site_setting).permit(:value)
  end
end
