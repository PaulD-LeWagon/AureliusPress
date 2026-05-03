require "rails_helper"

RSpec.describe "AureliusPress::Admin::Settings", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:regular_user) { create(:aurelius_press_user) }

  before do
    AureliusPress::SiteSetting.create!(key: "site_name", value: "AureliusPress", value_type: "string")
    AureliusPress::SiteSetting.create!(key: "registration_open", value: "true", value_type: "boolean")
  end

  describe "GET /aurelius-press/admin/settings" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns a successful response" do
        get aurelius_press_admin_settings_path
        expect(response).to have_http_status(:ok)
      end

      it "exposes all settings" do
        get aurelius_press_admin_settings_path
        expect(assigns(:settings)).to be_present
        expect(assigns(:settings)).to all(be_a(AureliusPress::SiteSetting))
      end
    end

    context "when authenticated as a regular user" do
      before { sign_in regular_user }

      it "is forbidden or redirected" do
        get aurelius_press_admin_settings_path
        expect(response).to have_http_status(:forbidden).or redirect_to(root_path)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        get aurelius_press_admin_settings_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /aurelius-press/admin/settings/:id" do
    let(:setting) { AureliusPress::SiteSetting.find_by!(key: "site_name") }

    context "when authenticated as admin" do
      before { sign_in admin }

      it "updates the setting value" do
        patch aurelius_press_admin_setting_path(setting), params: { aurelius_press_site_setting: { value: "My Site" } }
        expect(setting.reload.value).to eq("My Site")
      end

      it "redirects to the settings index" do
        patch aurelius_press_admin_setting_path(setting), params: { aurelius_press_site_setting: { value: "My Site" } }
        expect(response).to redirect_to(aurelius_press_admin_settings_path)
      end
    end

    context "when authenticated as a regular user" do
      before { sign_in regular_user }

      it "is forbidden or redirected" do
        patch aurelius_press_admin_setting_path(setting), params: { aurelius_press_site_setting: { value: "Hack" } }
        expect(response).to have_http_status(:forbidden).or redirect_to(root_path)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        patch aurelius_press_admin_setting_path(setting), params: { aurelius_press_site_setting: { value: "Hack" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
