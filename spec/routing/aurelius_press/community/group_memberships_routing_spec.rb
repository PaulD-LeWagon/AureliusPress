require "rails_helper"

RSpec.describe AureliusPress::Community::GroupMembershipsController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/aurelius-press/community/group-memberships").to route_to("aurelius_press/community/group_memberships#create")
    end

    it "routes to #destroy" do
      expect(delete: "/aurelius-press/community/group-memberships/1").to route_to("aurelius_press/community/group_memberships#destroy", id: "1")
    end

    it "does not route to #index" do
      expect(get: "/aurelius-press/community/group-memberships").not_to be_routable
    end

    it "does not route to #show" do
      expect(get: "/aurelius-press/community/group-memberships/1").not_to be_routable
    end
  end
end
