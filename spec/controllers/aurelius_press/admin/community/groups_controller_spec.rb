require "rails_helper"

RSpec.describe AureliusPress::Admin::Community::GroupsController, type: :controller do
  render_views # Ensure views are rendered for template checks

  let(:moderator_user) { create(:aurelius_press_moderator_user) }
  let(:creator) { create(:aurelius_press_user) }

  before do
    sign_in moderator_user
  end

  after do
    sign_out moderator_user
  end

  # Attributes for DIRECTLY CREATING records (e.g., with FactoryBot's `create`)
  let(:record_attributes) {
    {
      name: "Test Group",
      description: "A group for testing purposes.",
      creator: creator,
    }
  }

  # Attributes for CONTROLLER PARAMETERS (what comes from a web form POST/PATCH)
  let(:param_attributes) {
    {
      name: "New Discussion Group",
      description: "A newly formed group for engaging discussions.",
      creator_id: creator.id,
      # status: "active",
      # privacy_setting: "public_group"
    }
  }

  # Invalid attributes for CONTROLLER PARAMETERS (for testing validation failures)
  let(:invalid_param_attributes) {
    {
      name: "",
      description: "Description for a group with no name.",
      creator_id: creator.id,
      status: :active,
      privacy_setting: :public_group
    }
  }

  describe "GET #index" do
    it "returns a successful response and assigns @groups" do
      AureliusPress::Community::Group.create!(record_attributes)
      get :index
      expect(response).to be_successful
      expect(assigns(:groups)).to_not be_nil
      expect(assigns(:groups)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @group" do
      group = AureliusPress::Community::Group.create!(record_attributes)
      get :show, params: { id: group.id }
      expect(response).to be_successful
      expect(assigns(:group)).to eq(group)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:group)).to be_a_new(AureliusPress::Community::Group)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Group" do
        expect {
          post :create, params: { aurelius_press_community_group: param_attributes }
        }.to change(AureliusPress::Community::Group, :count).by(1)
      end

      it "redirects to the created group" do
        post :create, params: { aurelius_press_community_group: param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_community_group_path(AureliusPress::Community::Group.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Group" do
        expect {
          post :create, params: { aurelius_press_community_group: invalid_param_attributes }
        }.to_not change(AureliusPress::Community::Group, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_community_group: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @group" do
      group = AureliusPress::Community::Group.create!(record_attributes)
      get :edit, params: { id: group.id }
      expect(response).to be_successful
      expect(assigns(:group)).to eq(group)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:group_to_update) { AureliusPress::Community::Group.create!(record_attributes) }
      let(:new_valid_param_attributes) { { name: "Updated Group Name" } }

      it "updates the requested group" do
        patch :update, params: { id: group_to_update.id, aurelius_press_community_group: new_valid_param_attributes }
        group_to_update.reload
        expect(group_to_update.name).to eq(new_valid_param_attributes[:name])
      end

      it "redirects to the group" do
        patch :update, params: { id: group_to_update.id, aurelius_press_community_group: new_valid_param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_community_group_path(group_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:group_to_update) { AureliusPress::Community::Group.create!(record_attributes) }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: group_to_update.id, aurelius_press_community_group: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the group" do
        original_name = group_to_update.name
        patch :update, params: { id: group_to_update.id, aurelius_press_community_group: invalid_param_attributes }
        group_to_update.reload
        expect(group_to_update.name).to eq(original_name)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested group" do
      group = AureliusPress::Community::Group.create!(record_attributes)
      expect {
        delete :destroy, params: { id: group.id }
      }.to change(AureliusPress::Community::Group, :count).by(-1)
    end

    it "redirects to the groups list" do
      group = AureliusPress::Community::Group.create!(record_attributes)
      delete :destroy, params: { id: group.id }
      expect(response).to redirect_to(aurelius_press_admin_community_groups_url)
    end
  end
end
