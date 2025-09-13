require "rails_helper"

RSpec.describe "AtomicBlogPost Routes", type: :routing do
  describe "atomic_blog_posts routes" do
    it "routes GET /aurelius-press/atomic-blog-posts to aurelius_press/document/atomic_blog_posts#index" do
      expect(get("/aurelius-press/atomic-blog-posts")).to route_to("aurelius_press/document/atomic_blog_posts#index")
    end

    it "routes GET /aurelius-press/atomic-blog-posts/1 to aurelius_press/document/atomic_blog_posts#show" do
      expect(get("/aurelius-press/atomic-blog-posts/1")).to route_to("aurelius_press/document/atomic_blog_posts#show", id: "1")
    end

    it "routes POST /aurelius-press/atomic-blog-posts to aurelius_press/document/atomic_blog_posts#create" do
      expect(post("/aurelius-press/atomic-blog-posts")).to route_to("aurelius_press/document/atomic_blog_posts#create")
    end

    it "routes PATCH /aurelius-press/atomic-blog-posts/1 to aurelius_press/document/atomic_blog_posts#update" do
      expect(patch("/aurelius-press/atomic-blog-posts/1")).to route_to("aurelius_press/document/atomic_blog_posts#update", id: "1")
    end

    it "routes PUT /aurelius-press/atomic-blog-posts/1 to aurelius_press/document/atomic_blog_posts#update" do
      expect(put("/aurelius-press/atomic-blog-posts/1")).to route_to("aurelius_press/document/atomic_blog_posts#update", id: "1")
    end

    it "routes DELETE /aurelius-press/atomic-blog-posts/1 to aurelius_press/document/atomic_blog_posts#destroy" do
      expect(delete("/aurelius-press/atomic-blog-posts/1")).to route_to("aurelius_press/document/atomic_blog_posts#destroy", id: "1")
    end
  end
end
