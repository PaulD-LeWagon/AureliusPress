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

  describe "GET the users /new" do
    it "returns http success" do
      get aurelius_press_admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "POST the users /create" do
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

  describe "GET the users /edit" do
    it "returns http success" do
      get edit_aurelius_press_admin_user_path(aurelius_press_user)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "PATCH /users/:id" do
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

  describe "DELETE /users/:slug" do
    it "destroys the requested user and redirects to the users list" do
      # Ensure the user to be deleted exists before the delete action
      expect(aurelius_press_user).to be_persisted
      # Check that the user exists in the database
      expect(AureliusPress::User.exists?(aurelius_press_user.id)).to be true
      # The user count is 2 because one user is created by the let statement above
      # and another user is created by the sign_in method in the before block.
      expect(AureliusPress::User.count).to eq(2)
      # Perform the delete action
      delete aurelius_press_admin_user_path(aurelius_press_user)
      # After deletion, the user count should decrease by one.
      expect(AureliusPress::User.count).to eq(1)
      # Verify that the specific user has been removed from the database.
      expect(AureliusPress::User.exists?(aurelius_press_user.id)).to be false
      # Check that the response status is a redirect (302)
      # Possible status codes to check for:
      # :success (200-299): The request was successfully handled.
      # :redirect (300-399): The browser needs to take further action to complete the request.
      # :client_error (400-499): The request contained an error and could not be completed.
      # :server_error (500-599): An error occurred on the server while processing the request.
      #
      # More specific status codes include:
      # :ok(200)
      # :created(201)
      # :no_content(204)
      # :bad_request(400)
      # :unauthorized(401)
      # :forbidden(403)
      # :not_found(404)
      # :unprocessable_entity(422)
      # :internal_server_error(500)
      # After deletion, the user should be redirected to the users list,
      # which typically results in a 302 status code.
      expect(response).to have_http_status(302)
      # After deletion, the user should be redirected to the users list
      expect(response).to redirect_to(aurelius_press_admin_users_path)
    end

    ## These are the more concise and conventional versions of the above test.
    # it "destroys the requested user" do
    #   expect {
    #     delete aurelius_press_admin_user_path(aurelius_press_user)
    #   }.to change(AureliusPress::User, :count).by(-1)
    # end
    #
    # it "redirects to the users list" do
    #   delete aurelius_press_admin_user_path(aurelius_press_user)
    #   expect(response).to have_http_status(:found)
    #   expect(response).to redirect_to(aurelius_press_admin_users_path)
    # end
  end
end
