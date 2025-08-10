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
end
