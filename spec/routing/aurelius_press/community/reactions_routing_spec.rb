require "rails_helper"

RSpec.describe AureliusPress::Community::ReactionsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/aurelius-press/community/reactions").to route_to("aurelius_press/community/reactions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/aurelius-press/community/reactions/1").to route_to("aurelius_press/community/reactions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/aurelius-press/community/reactions/1").to route_to("aurelius_press/community/reactions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/aurelius-press/community/reactions/1").to route_to("aurelius_press/community/reactions#destroy", id: "1")
    end
  end
end
