require "rails_helper"

RSpec.describe "Page Routes", type: :routing do
  describe "pages routes" do
    it "routes GET /aurelius-press/pages to aurelius_press/document/pages#index" do
      expect(get("/aurelius-press/pages")).to route_to("aurelius_press/document/pages#index")
    end

    it "routes GET /aurelius-press/pages/1 to aurelius_press/document/pages#show" do
      expect(get("/aurelius-press/pages/1")).to route_to("aurelius_press/document/pages#show", id: "1")
    end

    it "routes POST /aurelius-press/pages to aurelius_press/document/pages#create" do
      expect(post("/aurelius-press/pages")).to route_to("aurelius_press/document/pages#create")
    end

    it "routes PATCH /aurelius-press/pages/1 to aurelius_press/document/pages#update" do
      expect(patch("/aurelius-press/pages/1")).to route_to("aurelius_press/document/pages#update", id: "1")
    end

    it "routes PUT /aurelius-press/pages/1 to aurelius_press/document/pages#update" do
      expect(put("/aurelius-press/pages/1")).to route_to("aurelius_press/document/pages#update", id: "1")
    end

    it "routes DELETE /aurelius-press/pages/1 to aurelius_press/document/pages#destroy" do
      expect(delete("/aurelius-press/pages/1")).to route_to("aurelius_press/document/pages#destroy", id: "1")
    end
  end
end
