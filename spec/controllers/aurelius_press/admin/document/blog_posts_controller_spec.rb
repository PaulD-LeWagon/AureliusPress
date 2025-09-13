require "rails_helper"

RSpec.describe AureliusPress::Admin::Document::BlogPostsController, type: :controller do
  render_views

  let!(:admin_user) { create(:aurelius_press_admin_user) }
  let!(:user) { create(:aurelius_press_user) }

  before do
    sign_in admin_user
  end

  after do
    sign_out admin_user
  end

  let!(:blog_post) do
    create(:aurelius_press_document_blog_post,
           user: user,
           category: create(:aurelius_press_taxonomy_category),
           type: "AureliusPress::Document::BlogPost",
           title: "#1. My Exceptional Blog Post Title",
           slug: "1-my-exceptional-blog-post-title",
           subtitle: "An exceptional blog post subtitle",
           status: :published,
           visibility: :public_to_www)
  end

  let(:param_attributes) do
    {
      user_id: blog_post.user.id,
      category_id: blog_post.category.id,
      type: blog_post.type,
      title: blog_post.title,
      slug: blog_post.slug,
      subtitle: blog_post.subtitle,
      status: blog_post.status,
      visibility: blog_post.visibility,
    }
  end

  let(:invalid_param_attributes) do
    {
      user_id: blog_post.user.id,
      title: "",
      status: :published,
      visibility: :public_to_www,
    }
  end

  describe "GET #index" do
    it "returns a successful response and assigns @blog_posts" do
      create(:aurelius_press_document_blog_post)
      get :index
      expect(response).to be_successful
      expect(assigns(:blog_posts)).to_not be_nil
      expect(assigns(:blog_posts)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @blog_post" do
      get :show, params: { id: blog_post.slug }
      expect(response).to be_successful
      expect(assigns(:blog_post)).to eq(blog_post)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:blog_post)).to be_a_new(AureliusPress::Document::BlogPost)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new BlogPost" do
        expect {
          post :create, params: { aurelius_press_document_blog_post: param_attributes }
        }.to change(AureliusPress::Document::BlogPost, :count).by(1)
      end

      it "redirects to the created blog post" do
        post :create, params: { aurelius_press_document_blog_post: param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_document_blog_post_path(AureliusPress::Document::BlogPost.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new BlogPost" do
        expect {
          post :create, params: { aurelius_press_document_blog_post: invalid_param_attributes }
        }.to_not change(AureliusPress::Document::BlogPost, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_document_blog_post: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @blog_post" do
      get :edit, params: { id: blog_post.slug }
      expect(response).to be_successful
      expect(assigns(:blog_post)).to eq(blog_post)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:blog_post_to_update) { blog_post }
      let(:new_valid_param_attributes) { { title: "#2. Updated Blog Post Title" }.merge(param_attributes) }

      it "updates the requested blog post" do
        patch :update, params: { id: blog_post_to_update.slug, aurelius_press_document_blog_post: new_valid_param_attributes }
        blog_post_to_update.reload
        expect(blog_post_to_update.title).to eq(new_valid_param_attributes[:title])
      end

      it "redirects to the blog post" do
        patch :update, params: { id: blog_post_to_update.slug, aurelius_press_document_blog_post: new_valid_param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_document_blog_post_url(blog_post_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:blog_post_to_update) { blog_post }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: blog_post_to_update.slug, aurelius_press_document_blog_post: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the blog post" do
        original_title = blog_post_to_update.title
        patch :update, params: { id: blog_post_to_update.slug, aurelius_press_document_blog_post: invalid_param_attributes }
        blog_post_to_update.reload
        expect(blog_post_to_update.title).to eq(original_title)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested blog post" do
      expect {
        delete :destroy, params: { id: blog_post.slug }
      }.to change(AureliusPress::Document::BlogPost, :count).by(-1)
    end

    it "redirects to the blog posts list" do
      delete :destroy, params: { id: blog_post.slug }
      expect(response).to redirect_to(aurelius_press_admin_document_blog_posts_url)
    end
  end
end
