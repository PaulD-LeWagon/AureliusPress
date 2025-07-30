# spec/routing/aurelius_press/admin/catalogue/authors_routing_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Admin::Catalogue::AuthorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/aurelius-press/admin/catalogue/authors").to route_to("aurelius_press/admin/catalogue/authors#index")
    end

    it "routes to #new" do
      expect(get: "/aurelius-press/admin/catalogue/authors/new").to route_to("aurelius_press/admin/catalogue/authors#new")
    end

    it "routes to #show" do
      expect(get: "/aurelius-press/admin/catalogue/authors/1").to route_to("aurelius_press/admin/catalogue/authors#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/aurelius-press/admin/catalogue/authors/1/edit").to route_to("aurelius_press/admin/catalogue/authors#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/aurelius-press/admin/catalogue/authors").to route_to("aurelius_press/admin/catalogue/authors#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/aurelius-press/admin/catalogue/authors/1").to route_to("aurelius_press/admin/catalogue/authors#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/aurelius-press/admin/catalogue/authors/1").to route_to("aurelius_press/admin/catalogue/authors#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/aurelius-press/admin/catalogue/authors/1").to route_to("aurelius_press/admin/catalogue/authors#destroy", id: "1")
    end
  end
end
