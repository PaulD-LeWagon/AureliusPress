require "rails_helper"
require "action_dispatch/testing/test_process"

RSpec.describe AureliusPress::Admin::Document::AtomicBlogPostsController, type: :controller do
  render_views

  let!(:atomic_blog_post_record) do
    create(:aurelius_press_document_atomic_blog_post,
           user: create(:aurelius_press_user),
           category: create(:aurelius_press_taxonomy_category),
           title: "My Atomic Blog Post",
           slug: "my-atomic-blog-post",
           subtitle: "A short, focused post.",
           status: :published,
           visibility: :public_to_www,
           content: "<h1>This is the initial <i>rich</i> text content.</h1>",
           image_file: fixture_file_upload("another_image.png", "image/png"))
  end

  # Valid attributes for creating a *new* AtomicBlogPost, ensuring uniqueness for title/slug
  let(:param_attributes) do
    {
      user_id: create(:aurelius_press_user).id,
      category_id: create(:aurelius_press_taxonomy_category).id,
      title: "New Atomic Post Title #{SecureRandom.hex(4)}",
      slug: "new-atomic-post-title-#{SecureRandom.hex(4)}",
      subtitle: "A subtitle for a new atomic blog post.",
      status: :draft,
      visibility: :private_to_owner,
      content: "Content for the new atomic blog post.",
      image_file: fixture_file_upload("test_image.png", "image/png"),
    }
  end

  # Invalid attributes for controller parameters
  let(:invalid_param_attributes) do
    {
      user_id: atomic_blog_post_record.user.id,
      title: "",
      content: "",
      image_file: nil,
      status: :published,
      visibility: :public_to_www,
    }
  end

  describe "GET #index" do
    it "returns a successful response and assigns @atomic_blog_posts" do
      create(:aurelius_press_document_atomic_blog_post)
      get :index
      expect(response).to be_successful
      expect(assigns(:atomic_blog_posts)).to_not be_nil
      expect(assigns(:atomic_blog_posts)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @atomic_blog_post" do
      get :show, params: { id: atomic_blog_post_record.id }
      expect(response).to be_successful
      expect(assigns(:atomic_blog_post)).to eq(atomic_blog_post_record)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:atomic_blog_post)).to be_a_new(AureliusPress::Document::AtomicBlogPost)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new AtomicBlogPost" do
        expect {
          post :create, params: { aurelius_press_document_atomic_blog_post: param_attributes }
        }.to change(AureliusPress::Document::AtomicBlogPost, :count).by(1)
      end

      it "redirects to the created atomic blog post" do
        post :create, params: { aurelius_press_document_atomic_blog_post: param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_document_atomic_blog_post_path(AureliusPress::Document::AtomicBlogPost.last))
      end

      it "attaches the image and saves rich text content" do
        post :create, params: { aurelius_press_document_atomic_blog_post: param_attributes }
        new_post = AureliusPress::Document::AtomicBlogPost.last
        expect(new_post.image_file).to be_attached
        expect(new_post.image_file).to be_a(ActiveStorage::Attached::One)
        expect(new_post.content.to_plain_text).to eq(param_attributes[:content])
        expect(new_post.content).to be_a(ActionText::RichText)
      end
    end

    context "with invalid parameters" do
      it "does not create a new AtomicBlogPost" do
        expect {
          post :create, params: { aurelius_press_document_atomic_blog_post: invalid_param_attributes }
        }.to_not change(AureliusPress::Document::AtomicBlogPost, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_document_atomic_blog_post: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @atomic_blog_post" do
      get :edit, params: { id: atomic_blog_post_record.id }
      expect(response).to be_successful
      expect(assigns(:atomic_blog_post)).to eq(atomic_blog_post_record)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:atomic_blog_post_to_update) { atomic_blog_post_record }

      # Provide only the attributes that are changing for the update test
      let(:new_valid_param_attributes) do
        {
          title: "Updated Atomic Post Title #{SecureRandom.hex(4)}",
          content: "This is the updated rich text content.",
          image_file: fixture_file_upload("another_image.png", "image/png"), # Provide a different image for update
        }
      end

      it "updates the requested atomic blog post" do
        patch :update, params: { id: atomic_blog_post_to_update.id, aurelius_press_document_atomic_blog_post: new_valid_param_attributes }
        atomic_blog_post_to_update.reload
        expect(atomic_blog_post_to_update.title).to eq(new_valid_param_attributes[:title])
        expect(atomic_blog_post_to_update.content.to_plain_text).to eq(new_valid_param_attributes[:content])
        expect(atomic_blog_post_to_update.content).to be_a(ActionText::RichText)
        expect(atomic_blog_post_to_update.image_file).to be_attached
        expect(atomic_blog_post_to_update.image_file.filename.to_s).to eq("another_image.png")
        expect(atomic_blog_post_to_update.image_file).to be_a(ActiveStorage::Attached::One)
      end

      it "redirects to the atomic blog post" do
        patch :update, params: { id: atomic_blog_post_to_update.id, aurelius_press_document_atomic_blog_post: new_valid_param_attributes }
        atomic_blog_post_to_update.reload
        expect(response).to redirect_to(aurelius_press_admin_document_atomic_blog_post_url(atomic_blog_post_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:atomic_blog_post_to_update) { atomic_blog_post_record }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: atomic_blog_post_to_update.id, aurelius_press_document_atomic_blog_post: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the atomic blog post" do
        original_title = atomic_blog_post_to_update.title
        original_content = atomic_blog_post_to_update.content
        patch :update, params: { id: atomic_blog_post_to_update.id, aurelius_press_document_atomic_blog_post: invalid_param_attributes }
        atomic_blog_post_to_update.reload
        expect(atomic_blog_post_to_update.title).to eq(original_title)
        expect(atomic_blog_post_to_update.content).to eq(original_content)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested atomic blog post" do
      atomic_post_to_destroy = create(:aurelius_press_document_atomic_blog_post, user: create(:aurelius_press_user), category: create(:aurelius_press_taxonomy_category))
      expect {
        delete :destroy, params: { id: atomic_post_to_destroy.id }
      }.to change(AureliusPress::Document::AtomicBlogPost, :count).by(-1)
    end

    it "redirects to the atomic blog posts list" do
      atomic_post_to_destroy = create(:aurelius_press_document_atomic_blog_post, user: create(:aurelius_press_user), category: create(:aurelius_press_taxonomy_category))
      delete :destroy, params: { id: atomic_post_to_destroy.id }
      expect(response).to redirect_to(aurelius_press_admin_document_atomic_blog_posts_url)
    end
  end
end
