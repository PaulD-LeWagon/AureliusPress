require "rails_helper"

RSpec.describe "BlogPost Routes", type: :routing do
  describe "blog_posts routes" do
    it "routes GET /aurelius-press/blog-posts to blog_posts#index" do
      expect(get("/aurelius-press/blog-posts")).to route_to("blog_posts#index")
    end

    it "routes GET /aurelius-press/blog-posts/1 to blog_posts#show" do
      expect(get("/aurelius-press/blog-posts/1")).to route_to("blog_posts#show", id: "1")
    end

    it "routes POST /aurelius-press/blog-posts to blog_posts#create" do
      expect(post("/aurelius-press/blog-posts")).to route_to("blog_posts#create")
    end

    it "routes PATCH /aurelius-press/blog-posts/1 to blog_posts#update" do
      expect(patch("/aurelius-press/blog-posts/1")).to route_to("blog_posts#update", id: "1")
    end

    it "routes PUT /aurelius-press/blog-posts/1 to blog_posts#update" do
      expect(put("/aurelius-press/blog-posts/1")).to route_to("blog_posts#update", id: "1")
    end

    it "routes DELETE /aurelius-press/blog-posts/1 to blog_posts#destroy" do
      expect(delete("/aurelius-press/blog-posts/1")).to route_to("blog_posts#destroy", id: "1")
    end
  end
end
