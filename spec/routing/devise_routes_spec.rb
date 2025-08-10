require "rails_helper"
# Devise routes for user authentication
RSpec.describe "Devise Routes (aurelius-press)", type: :routing do
  describe "Devise Authorisation Routes" do
    it "routes /aurelius-press/users/sign_in to devise/sessions#new" do
      expect(get("/aurelius-press/users/sign_in")).to route_to("devise/sessions#new")
    end
    it "routes /aurelius-press/users/sign_out to devise/sessions#destroy" do
      expect(delete("/aurelius-press/users/sign_out")).to route_to("devise/sessions#destroy")
    end
    it "routes /aurelius-press/users/sign_up to devise/registrations#new" do
      expect(get("/aurelius-press/users/sign_up")).to route_to("devise/registrations#new")
    end
    it "routes /aurelius-press/users/password/new to devise/passwords#new" do
      expect(get("/aurelius-press/users/password/new")).to route_to("devise/passwords#new")
    end
    it "routes /aurelius-press/users/password to devise/passwords#create" do
      expect(post("/aurelius-press/users/password")).to route_to("devise/passwords#create")
    end
    it "routes /aurelius-press/users/password/edit to devise/passwords#edit" do
      expect(get("/aurelius-press/users/password/edit")).to route_to("devise/passwords#edit")
    end
    it "routes /aurelius-press/users/password to devise/passwords#update" do
      expect(patch("/aurelius-press/users/password")).to route_to("devise/passwords#update")
    end
    it "routes /aurelius-press/users/confirmation/new to devise/confirmations#new" do
      skip "Not yet implemented"
      expect(get("/aurelius-press/users/confirmation/new")).to route_to("devise/confirmations#new")
    end
    it "routes /aurelius-press/users/confirmation to devise/confirmations#create" do
      skip "Not yet implemented"
      expect(post("/aurelius-press/users/confirmation")).to route_to("devise/confirmations#create")
    end
    it "routes /aurelius-press/users/confirmation to devise/confirmations#show" do
      skip "Not yet implemented"
      expect(get("/aurelius-press/users/confirmation")).to route_to("devise/confirmations#show")
    end
    it "routes /aurelius-press/users/registration/edit to devise/registrations#edit" do
      expect(get("/aurelius-press/users/edit")).to route_to("devise/registrations#edit")
    end
    it "routes /aurelius-press/users/registration to devise/registrations#update" do
      expect(patch("/aurelius-press/users")).to route_to("devise/registrations#update")
    end
    it "routes /aurelius-press/users/registration to devise/registrations#create" do
      expect(post("/aurelius-press/users")).to route_to("devise/registrations#create")
    end
    it "routes /aurelius-press/users/cancel to devise/registrations#cancel" do
      expect(get("/aurelius-press/users/cancel")).to route_to("devise/registrations#cancel")
    end
  end
end
