require "rails_helper"
# Devise routes for user authentication
RSpec.describe "Devise Routes", type: :routing do
  describe "Devise Authorisation Routes" do
    it "routes /users/sign_in to devise/sessions#new" do
      expect(get("/users/sign_in")).to route_to("devise/sessions#new")
    end
    it "routes /users/sign_out to devise/sessions#destroy" do
      expect(delete("/users/sign_out")).to route_to("devise/sessions#destroy")
    end
    it "routes /users/sign_up to devise/registrations#new" do
      expect(get("/users/sign_up")).to route_to("devise/registrations#new")
    end
    it "routes /users/password/new to devise/passwords#new" do
      expect(get("/users/password/new")).to route_to("devise/passwords#new")
    end
    it "routes /users/password to devise/passwords#create" do
      expect(post("/users/password")).to route_to("devise/passwords#create")
    end
    it "routes /users/password/edit to devise/passwords#edit" do
      expect(get("/users/password/edit")).to route_to("devise/passwords#edit")
    end
    it "routes /users/password to devise/passwords#update" do
      expect(patch("/users/password")).to route_to("devise/passwords#update")
    end
    it "routes /users/confirmation/new to devise/confirmations#new" do
      expect(get("/users/confirmation/new")).to route_to("devise/confirmations#new")
    end
    it "routes /users/confirmation to devise/confirmations#create" do
      expect(post("/users/confirmation")).to route_to("devise/confirmations#create")
    end
    it "routes /users/confirmation to devise/confirmations#show" do
      expect(get("/users/confirmation")).to route_to("devise/confirmations#show")
    end
    it "routes /users/registration/edit to devise/registrations#edit" do
      expect(get("/users/edit")).to route_to("devise/registrations#edit")
    end
    it "routes /users/registration to devise/registrations#update" do
      expect(patch("/users")).to route_to("devise/registrations#update")
    end
    it "routes /users/registration to devise/registrations#create" do
      expect(post("/users")).to route_to("devise/registrations#create")
    end
    it "routes /users/cancel to devise/registrations#cancel" do
      expect(get("/users/cancel")).to route_to("devise/registrations#cancel")
    end
  end
end
