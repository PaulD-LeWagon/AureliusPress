# spec/routing/aurelius_press/catalogue/sources_routing_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Catalogue::SourcesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/aurelius-press/catalogue/sources").to route_to("aurelius_press/catalogue/sources#index")
    end

    it "routes to #show" do
      expect(get: "/aurelius-press/catalogue/sources/marcus-aurelius").to route_to("aurelius_press/catalogue/sources#show", slug: "marcus-aurelius")
    end

    # Ensure other actions are NOT routed publicly
    it "does not route to #new" do
      expect(get: "/aurelius-press/catalogue/sources/new").to_not be_routable
    end

    it "does not route to #edit" do
      expect(get: "/aurelius-press/catalogue/sources/1/edit").to_not be_routable
    end

    it "does not route to #create" do
      expect(post: "/aurelius-press/catalogue/sources").to_not be_routable
    end

    it "does not route to #update via PUT" do
      expect(put: "/aurelius-press/catalogue/sources/1").to_not be_routable
    end

    it "does not route to #update via PATCH" do
      expect(patch: "/aurelius-press/catalogue/sources/1").to_not be_routable
    end

    it "does not route to #destroy" do
      expect(delete: "/aurelius-press/catalogue/sources/1").to_not be_routable
    end
  end
end
