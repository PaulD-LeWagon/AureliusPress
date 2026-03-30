require "rails_helper"

RSpec.describe AureliusPress::User, type: :request do
  # A user is created here for the show, edit, and destroy tests.
  let!(:aurelius_press_user) { create(:aurelius_press_user) }
  # The admin user is signed in once for all tests in this file.
  before do
    sign_in create(:aurelius_press_admin_user)
  end

  describe "GET the users /index" do
    it "returns http success" do
      get aurelius_press_admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET the users /show" do
    it "returns http success" do
      get aurelius_press_admin_user_path(aurelius_press_user)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /aurelius-press/admin/users/new" do
    it "returns http success" do
      get new_aurelius_press_admin_user_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "POST /aurelius-press/admin/users" do
    context "with valid parameters" do
      let(:valid_attributes) { attributes_for(:aurelius_press_user) }

      it "creates a new user" do
        expect {
          post aurelius_press_admin_users_path, params: { aurelius_press_user: valid_attributes }
        }.to change(AureliusPress::User, :count).by(1)
      end

      it "redirects to the created user" do
        post aurelius_press_admin_users_path, params: { aurelius_press_user: valid_attributes }
        expect(response).to redirect_to(aurelius_press_admin_user_path(AureliusPress::User.last))
      end
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /aurelius-press/admin/users/:id/edit" do
    it "returns http success" do
      get edit_aurelius_press_admin_user_path(aurelius_press_user)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "PATCH /aurelius-press/admin/users/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { first_name: "Newname" } }

      it "updates the requested user" do
        patch aurelius_press_admin_user_path(aurelius_press_user), params: { aurelius_press_user: new_attributes }
        aurelius_press_user.reload
        expect(aurelius_press_user.first_name).to eq("Newname")
      end

      it "redirects to the user" do
        patch aurelius_press_admin_user_path(aurelius_press_user), params: { aurelius_press_user: new_attributes }
        expect(response).to redirect_to(aurelius_press_admin_user_path(aurelius_press_user))
      end
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "DELETE /aurelius-press/admin/users/:id" do
    it "destroys the requested user and redirects to the users list" do
      expect(aurelius_press_user).to be_persisted
      expect(AureliusPress::User.exists?(aurelius_press_user.id)).to be true
      
      expect {
        delete aurelius_press_admin_user_path(aurelius_press_user)
      }.to change(AureliusPress::User, :count).by(-1)

      expect(response).to redirect_to(aurelius_press_admin_users_path)
    end
  end
end
