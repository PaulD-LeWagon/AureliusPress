require "rails_helper"

RSpec.describe AureliusPress::Admin::UsersController, type: :controller do
  render_views

  let!(:user_record) do
    create(:aurelius_press_user,
           email: "existing.user@example.com",
           first_name: "Paul",
           last_name: "Devanney",
           username: "harry-the-bastard",
           status: :active,
           role: :user,
           bio: "This is the biography for the existing user record.")
  end

  # Valid attributes for creating a *new* User, ensuring uniqueness for email
  let(:param_attributes) do
    {
      email: "new.user-#{SecureRandom.hex(4)}@example.com", # Ensure uniqueness
      first_name: "Thomas A.",
      last_name: "Anderson",
      username: "neo",
      password: "take-the-red-pill",
      password_confirmation: "take-the-red-pill",
      status: :active,
      role: :superuser,
      bio: "In the Matrix, you can be anything you want. I choose to be The Superuser.",
    }
  end

  # Invalid attributes for controller parameters
  let(:invalid_param_attributes) do
    {
      email: "",
      username: "_",
      password: "short",
      password_confirmation: "mismatch",
      status: :active,
      role: :reader,
    }
  end

  before do
    sign_in user_record # Sign in the existing user to access admin area
  end

  after do
    sign_out user_record # Sign out the user after each test
  end

  describe "GET #index" do
    it "returns a successful response and assigns @users" do
      create(:aurelius_press_user) # Create another user to ensure collection
      get :index
      expect(response).to be_successful
      expect(assigns(:users)).to_not be_nil
      expect(assigns(:users)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @user" do
      get :show, params: { id: user_record.id }
      expect(response).to be_successful
      expect(assigns(:user)).to eq(user_record)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:user)).to be_a_new(AureliusPress::User)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post :create, params: { aurelius_press_user: param_attributes }
        }.to change(AureliusPress::User, :count).by(1)
      end

      it "redirects to the created user" do
        post :create, params: { aurelius_press_user: param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_user_path(AureliusPress::User.last))
      end

      it "saves bio_content correctly" do
        post :create, params: { aurelius_press_user: param_attributes }
        new_user = AureliusPress::User.last
        expect(new_user.bio.to_plain_text).to eq(param_attributes[:bio])
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post :create, params: { aurelius_press_user: invalid_param_attributes }
        }.to_not change(AureliusPress::User, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_user: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @user" do
      get :edit, params: { id: user_record.id }
      expect(response).to be_successful
      expect(assigns(:user)).to eq(user_record)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:user_to_update) { user_record }

      # Provide only the attributes that are changing for the update test
      let(:new_valid_param_attributes) do
        {
          username: "Updated User Name",
          email: "updated.user-#{SecureRandom.hex(4)}@example.com", # New unique email
          bio: "This is the updated bio content.",
          role: :admin,
        }
      end

      it "updates the requested user" do
        patch :update, params: { id: user_to_update.id, aurelius_press_user: new_valid_param_attributes }
        user_to_update.reload
        expect(user_to_update.username).to eq(new_valid_param_attributes[:username])
        expect(user_to_update.email).to eq(new_valid_param_attributes[:email])
        expect(user_to_update.bio.to_plain_text).to eq(new_valid_param_attributes[:bio])
        expect(user_to_update.role).to eq(new_valid_param_attributes[:role].to_s)
      end

      it "redirects to the user" do
        patch :update, params: { id: user_to_update.id, aurelius_press_user: new_valid_param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_user_url(user_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:user_to_update) { user_record }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: user_to_update.id, aurelius_press_user: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the user" do
        original_username = user_to_update.username
        original_email = user_to_update.email
        patch :update, params: { id: user_to_update.id, aurelius_press_user: invalid_param_attributes }
        user_to_update.reload
        expect(user_to_update.username).to eq(original_username)
        expect(user_to_update.email).to eq(original_email)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      # Create a user specifically for destruction to avoid affecting other tests
      user_to_destroy = create(:aurelius_press_user)
      expect {
        delete :destroy, params: { id: user_to_destroy.id }
      }.to change(AureliusPress::User, :count).by(-1)
    end

    it "redirects to the users list" do
      user_to_destroy = create(:aurelius_press_user)
      delete :destroy, params: { id: user_to_destroy.id }
      expect(response).to redirect_to(aurelius_press_admin_users_url)
    end
  end
end
