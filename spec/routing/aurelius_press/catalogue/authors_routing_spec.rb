require "rails_helper"

RSpec.describe AureliusPress::Catalogue::AuthorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/aurelius-press/catalogue/authors").to route_to("aurelius_press/catalogue/authors#index")
    end

    it "routes to #show" do
      expect(get: "/aurelius-press/catalogue/authors/marcus-aurelius").to route_to("aurelius_press/catalogue/authors#show", slug: "marcus-aurelius")
    end

    # Ensure other actions are NOT routed publicly
    it "does not route to #new" do
      expect(get: "/aurelius-press/catalogue/authors/new").to_not be_routable
    end

    it "does not route to #edit" do
      expect(get: "/aurelius-press/catalogue/authors/marcus-aurelius/edit").to_not be_routable
    end

    it "does not route to #create" do
      expect(post: "/aurelius-press/catalogue/authors").to_not be_routable
    end

    it "does not route to #update via PUT" do
      expect(put: "/aurelius-press/catalogue/authors/marcus-aurelius").to_not be_routable
    end

    it "does not route to #update via PATCH" do
      expect(patch: "/aurelius-press/catalogue/authors/marcus-aurelius").to_not be_routable
    end

    it "does not route to #destroy" do
      expect(delete: "/aurelius-press/catalogue/authors/marcus-aurelius").to_not be_routable
    end
  end
end
