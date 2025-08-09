require "rails_helper"

RSpec.describe "Page Routes", type: :routing do
  describe "pages routes" do
    it "routes GET /aurelius-press/pages to pages#index" do
      expect(get("/aurelius-press/pages")).to route_to("pages#index")
    end

    it "routes GET /aurelius-press/pages/1 to pages#show" do
      expect(get("/aurelius-press/pages/1")).to route_to("pages#show", id: "1")
    end

    it "routes POST /aurelius-press/pages to pages#create" do
      expect(post("/aurelius-press/pages")).to route_to("pages#create")
    end

    it "routes PATCH /aurelius-press/pages/1 to pages#update" do
      expect(patch("/aurelius-press/pages/1")).to route_to("pages#update", id: "1")
    end

    it "routes PUT /aurelius-press/pages/1 to pages#update" do
      expect(put("/aurelius-press/pages/1")).to route_to("pages#update", id: "1")
    end

    it "routes DELETE /aurelius-press/pages/1 to pages#destroy" do
      expect(delete("/aurelius-press/pages/1")).to route_to("pages#destroy", id: "1")
    end
  end
end
