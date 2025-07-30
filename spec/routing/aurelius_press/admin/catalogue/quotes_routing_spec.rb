# spec/routing/aurelius_press/admin/catalogue/quotes_routing_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Admin::Catalogue::QuotesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/aurelius-press/admin/catalogue/quotes").to route_to("aurelius_press/admin/catalogue/quotes#index")
    end

    it "routes to #new" do
      expect(get: "/aurelius-press/admin/catalogue/quotes/new").to route_to("aurelius_press/admin/catalogue/quotes#new")
    end

    it "routes to #show" do
      expect(get: "/aurelius-press/admin/catalogue/quotes/1").to route_to("aurelius_press/admin/catalogue/quotes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/aurelius-press/admin/catalogue/quotes/1/edit").to route_to("aurelius_press/admin/catalogue/quotes#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/aurelius-press/admin/catalogue/quotes").to route_to("aurelius_press/admin/catalogue/quotes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/aurelius-press/admin/catalogue/quotes/1").to route_to("aurelius_press/admin/catalogue/quotes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/aurelius-press/admin/catalogue/quotes/1").to route_to("aurelius_press/admin/catalogue/quotes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/aurelius-press/admin/catalogue/quotes/1").to route_to("aurelius_press/admin/catalogue/quotes#destroy", id: "1")
    end
  end
end
