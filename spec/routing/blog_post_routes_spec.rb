require "rails_helper"

RSpec.describe "BlogPost Routes", type: :routing do
  describe "blog_posts routes" do
    it "routes GET /blog-posts to blog_posts#index" do
      expect(get("/blog-posts")).to route_to("blog_posts#index")
    end

    it "routes GET /blog-posts/1 to blog_posts#show" do
      expect(get("/blog-posts/1")).to route_to("blog_posts#show", id: "1")
    end

    it "routes POST /blog-posts to blog_posts#create" do
      expect(post("/blog-posts")).to route_to("blog_posts#create")
    end

    it "routes PATCH /blog-posts/1 to blog_posts#update" do
      expect(patch("/blog-posts/1")).to route_to("blog_posts#update", id: "1")
    end

    it "routes PUT /blog-posts/1 to blog_posts#update" do
      expect(put("/blog-posts/1")).to route_to("blog_posts#update", id: "1")
    end

    it "routes DELETE /blog-posts/1 to blog_posts#destroy" do
      expect(delete("/blog-posts/1")).to route_to("blog_posts#destroy", id: "1")
    end
  end
end
