require "rails_helper"

RSpec.describe "General Routes", type: :routing do
  # Root route
  it "routes / to home#index" do
    expect(get("/")).to route_to("home#index")
  end
  # Home index route
  it "routes /home to home#index" do
    expect(get("/home")).to route_to("home#index")
  end

  describe "Meta Checks" do
    # Health check route
    it "routes /up to rails/health#show" do
      expect(get("/up")).to route_to("rails/health#show")
    end
    # Service worker route
    it "routes /service-worker to rails/pwa#service_worker" do
      expect(get("/service-worker")).to route_to("rails/pwa#service_worker")
    end
    # Manifest route
    it "routes /manifest to rails/pwa#manifest" do
      expect(get("/manifest")).to route_to("rails/pwa#manifest")
    end
  end

  describe "users routes" do
    it "routes GET /users/1 to users#show" do
      expect(get("/users/1")).to route_to("users#show", id: "1")
    end
    # @TODO: create, edit, destroy
  end

  describe "likes routes" do
    it "routes POST /likes to likes#create" do
      expect(post("/likes")).to route_to("likes#create")
    end

    it "routes DELETE /likes/1 to likes#destroy" do
      expect(delete("/likes/1")).to route_to("likes#destroy", id: "1")
    end

    it "routes PATCH /likes/1 to likes#update" do
      expect(patch("/likes/1")).to route_to("likes#update", id: "1")
    end
  end
end
