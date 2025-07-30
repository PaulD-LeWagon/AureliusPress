# spec/routing/aurelius_press/admin/catalogue/sources_routing_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Admin::Catalogue::SourcesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/aurelius-press/admin/catalogue/sources").to route_to("aurelius_press/admin/catalogue/sources#index")
    end

    it "routes to #new" do
      expect(get: "/aurelius-press/admin/catalogue/sources/new").to route_to("aurelius_press/admin/catalogue/sources#new")
    end

    it "routes to #show" do
      expect(get: "/aurelius-press/admin/catalogue/sources/1").to route_to("aurelius_press/admin/catalogue/sources#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/aurelius-press/admin/catalogue/sources/1/edit").to route_to("aurelius_press/admin/catalogue/sources#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/aurelius-press/admin/catalogue/sources").to route_to("aurelius_press/admin/catalogue/sources#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/aurelius-press/admin/catalogue/sources/1").to route_to("aurelius_press/admin/catalogue/sources#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/aurelius-press/admin/catalogue/sources/1").to route_to("aurelius_press/admin/catalogue/sources#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/aurelius-press/admin/catalogue/sources/1").to route_to("aurelius_press/admin/catalogue/sources#destroy", id: "1")
    end
  end
end
