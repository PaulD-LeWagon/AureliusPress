require "rails_helper"

RSpec.describe "Pages Routes", type: :routing do
  describe "pages routes" do
    it "routes GET /pages to pages#index" do
      expect(get("/pages")).to route_to("pages#index")
    end

    it "routes GET /pages/1 to pages#show" do
      expect(get("/pages/1")).to route_to("pages#show", id: "1")
    end

    it "routes POST /pages to pages#create" do
      expect(post("/pages")).to route_to("pages#create")
    end

    it "routes PATCH /pages/1 to pages#update" do
      expect(patch("/pages/1")).to route_to("pages#update", id: "1")
    end

    it "routes PUT /pages/1 to pages#update" do
      expect(put("/pages/1")).to route_to("pages#update", id: "1")
    end

    it "routes DELETE /pages/1 to pages#destroy" do
      expect(delete("/pages/1")).to route_to("pages#destroy", id: "1")
    end
  end
end
