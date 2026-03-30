require "rails_helper"

RSpec.describe "AureliusPress::Admin::Community::Groups", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:group) { create(:aurelius_press_community_group) }

  before do
    sign_in admin
  end

  describe "GET /aurelius-press/admin/community/groups" do
    it "returns http success" do
      get aurelius_press_admin_community_groups_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/community/groups/:id" do
    it "returns http success" do
      get aurelius_press_admin_community_group_path(group)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/community/groups/new" do
    it "returns http success" do
      get new_aurelius_press_admin_community_group_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /aurelius-press/admin/community/groups" do
    let(:valid_params) do
      {
        aurelius_press_community_group: {
          name: "The Stoic Circle",
          description: "A group dedicated to the study of Aurelius and Epictetus.",
          creator_id: admin.id,
          status: "active",
          privacy_setting: "public_group"
        }
      }
    end

    it "creates a new group" do
      expect {
        post aurelius_press_admin_community_groups_path, params: valid_params
      }.to change(AureliusPress::Community::Group, :count).by(1)

      new_group = AureliusPress::Community::Group.last
      expect(new_group.name).to eq("The Stoic Circle")
      expect(response).to redirect_to(aurelius_press_admin_community_group_path(new_group))
    end
  end

  describe "GET /aurelius-press/admin/community/groups/:id/edit" do
    it "returns http success" do
      get edit_aurelius_press_admin_community_group_path(group)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /aurelius-press/admin/community/groups/:id" do
    it "updates the group and redirects" do
      patch aurelius_press_admin_community_group_path(group), params: { aurelius_press_community_group: { name: "Updated Name" } }
      expect(group.reload.name).to eq("Updated Name")
      expect(response).to redirect_to(aurelius_press_admin_community_group_path(group))
    end
  end

  describe "DELETE /aurelius-press/admin/community/groups/:id" do
    it "destroys the group and redirects" do
      group_to_delete = create(:aurelius_press_community_group)
      expect {
        delete aurelius_press_admin_community_group_path(group_to_delete)
      }.to change(AureliusPress::Community::Group, :count).by(-1)
      expect(response).to redirect_to(aurelius_press_admin_community_groups_path)
    end
  end
end
