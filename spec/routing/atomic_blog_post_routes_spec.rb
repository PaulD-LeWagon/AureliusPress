require "rails_helper"

RSpec.describe "AtomicBlogPost Routes", type: :routing do
  describe "atomic_blog_posts routes" do
    it "routes GET /atomic-blog-posts to atomic_blog_posts#index" do
      expect(get("/atomic-blog-posts")).to route_to("atomic_blog_posts#index")
    end

    it "routes GET /atomic-blog-posts/1 to atomic_blog_posts#show" do
      expect(get("/atomic-blog-posts/1")).to route_to("atomic_blog_posts#show", id: "1")
    end

    it "routes POST /atomic-blog-posts to atomic_blog_posts#create" do
      expect(post("/atomic-blog-posts")).to route_to("atomic_blog_posts#create")
    end

    it "routes PATCH /atomic-blog-posts/1 to atomic_blog_posts#update" do
      expect(patch("/atomic-blog-posts/1")).to route_to("atomic_blog_posts#update", id: "1")
    end

    it "routes PUT /atomic-blog-posts/1 to atomic_blog_posts#update" do
      expect(put("/atomic-blog-posts/1")).to route_to("atomic_blog_posts#update", id: "1")
    end

    it "routes DELETE /atomic-blog-posts/1 to atomic_blog_posts#destroy" do
      expect(delete("/atomic-blog-posts/1")).to route_to("atomic_blog_posts#destroy", id: "1")
    end
  end
end
