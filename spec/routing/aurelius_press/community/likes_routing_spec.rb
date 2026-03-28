require "rails_helper"

RSpec.describe AureliusPress::Community::LikesController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/aurelius-press/community/likes").to route_to("aurelius_press/community/likes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/aurelius-press/community/likes/1").to route_to("aurelius_press/community/likes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/aurelius-press/community/likes/1").to route_to("aurelius_press/community/likes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/aurelius-press/community/likes/1").to route_to("aurelius_press/community/likes#destroy", id: "1")
    end
  end
end
