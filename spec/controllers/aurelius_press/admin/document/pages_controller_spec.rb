# spec/controllers/aurelius_press/admin/document/pages_controller_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Admin::Document::PagesController, type: :controller do
  render_views

  before do
    @admin_user = create(:aurelius_press_admin_user)
    @user = create(:aurelius_press_user)
    @category = create(:aurelius_press_taxonomy_category)
    @page_record = create(:aurelius_press_document_page,
                          user: @user,
                          category: @category,
                          title: "My Sample Page Title",
                          slug: "my-sample-page-title",
                          subtitle: "A concise subtitle for the page",
                          status: :published,
                          visibility: :public_to_www)

    # Valid attributes for creating a *new* Page, ensuring uniqueness for title/slug
    @param_attributes = {
      user_id: @user.id, # Create a new user to avoid conflicts if user_id is part of a unique index
      category_id: @category.id,
      title: "Brand New Page Title #{SecureRandom.hex(4)}", # Ensure uniqueness
      slug: "brand-new-page-title-#{SecureRandom.hex(4)}",   # Ensure uniqueness
      subtitle: "Another unique page subtitle",
      status: :published,
      visibility: :private_to_owner
    }

    # Invalid attributes for controller parameters
    @invalid_param_attributes = {
      id: @page_record.id,
      user_id: @user.id,
      title: "",
      content: "",
      status: :published,
      visibility: :public_to_www
    }

    sign_in @admin_user
  end

  after do
    sign_out @admin_user
  end

  describe "GET #index" do
    it "returns a successful response and assigns @pages" do
      create(:aurelius_press_document_page)
      get :index
      expect(response).to be_successful
      expect(assigns(:pages)).to_not be_nil
      expect(assigns(:pages)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @page" do
      get :show, params: { id: @page_record.slug }
      expect(response).to be_successful
      expect(assigns(:page)).to eq(@page_record)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:page)).to be_a_new(AureliusPress::Document::Page)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Page" do
        expect {
          post :create, params: { aurelius_press_document_page: @param_attributes }
        }.to change(AureliusPress::Document::Page, :count).by(1)
      end

      it "redirects to the created page" do
        post :create, params: { aurelius_press_document_page: @param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_document_page_path(AureliusPress::Document::Page.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Page" do
        expect {
          post :create, params: { aurelius_press_document_page: @invalid_param_attributes }
        }.to_not change(AureliusPress::Document::Page, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_document_page: @invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @page" do
      get :edit, params: { id: @page_record.slug }
      expect(response).to be_successful
      expect(assigns(:page)).to eq(@page_record)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:page_to_update) { @page_record }

      # Provide only the attributes that are changing for the update test
      let(:new_valid_param_attributes) do
        {
          title: "Updated Page Title #{SecureRandom.hex(4)}",
          subtitle: "Updated subtitle for the page",
        }
      end

      it "updates the requested page" do
        patch :update, params: { id: page_to_update.slug, aurelius_press_document_page: new_valid_param_attributes }
        page_to_update.reload
        expect(page_to_update.title).to eq(new_valid_param_attributes[:title])
        expect(page_to_update.subtitle).to eq(new_valid_param_attributes[:subtitle])
      end

      it "redirects to the page" do
        patch :update, params: { id: page_to_update.slug, aurelius_press_document_page: new_valid_param_attributes }
        page_to_update.reload
        expect(response).to redirect_to(aurelius_press_admin_document_page_url(page_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:page_to_update) { @page_record }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: page_to_update.slug, aurelius_press_document_page: @invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the page" do
        original_title = page_to_update.title
        original_subtitle = page_to_update.subtitle
        patch :update, params: { id: page_to_update.slug, aurelius_press_document_page: @invalid_param_attributes }
        page_to_update.reload
        expect(page_to_update.title).to eq(original_title)
        expect(page_to_update.subtitle).to eq(original_subtitle)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested page" do
      # Create a page specifically for destruction to avoid affecting other tests relying on page_record
      # page_to_destroy = create(:aurelius_press_document_page, user: create(:aurelius_press_user), category: create(:aurelius_press_taxonomy_category))
      page_to_destroy = @page_record
      expect {
        delete :destroy, params: { id: page_to_destroy.slug }
      }.to change(AureliusPress::Document::Page, :count).by(-1)
    end

    it "redirects to the pages list" do
      # page_to_destroy = create(:aurelius_press_document_page, user: create(:aurelius_press_user), category: create(:aurelius_press_taxonomy_category))
      page_to_destroy = @page_record
      delete :destroy, params: { id: page_to_destroy.slug }
      expect(response).to redirect_to(aurelius_press_admin_document_pages_url)
    end
  end
end
