require "rails_helper"

RSpec.describe AureliusPress::Document::Page, type: :request do
  let!(:aurelius_press_page) { create(:aurelius_press_document_page) }

  before do
    sign_in create(:aurelius_press_admin_user)
  end

  describe "GET /pages/index" do
    it "returns http success" do
      get aurelius_press_pages_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /pages/show" do
    it "returns http success" do
      get aurelius_press_page_path(aurelius_press_page)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /pages/new" do
    it "returns http success" do
      get new_aurelius_press_page_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "POST /pages/create" do
    context "with valid parameters" do
      let(:valid_attributes) { attributes_for(:aurelius_press_document_page, user_id: create(:aurelius_press_admin_user).id) }

      it "creates a new page" do
        expect {
          post aurelius_press_pages_path, params: { aurelius_press_document_page: valid_attributes }
        }.to change(AureliusPress::Document::Page, :count).by(1)
      end

      it "redirects to the created page" do
        post aurelius_press_pages_path, params: { aurelius_press_document_page: valid_attributes }
        expect(response).to redirect_to(aurelius_press_page_path(AureliusPress::Document::Page.last))
      end
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /pages/:slug/edit" do
    it "returns http success" do
      get edit_aurelius_press_page_path(aurelius_press_page)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "PATCH /pages/:slug" do
    context "with valid parameters" do
      let(:new_attributes) { { title: "The New Title" } }

      it "updates the requested page" do
        patch aurelius_press_page_path(aurelius_press_page), params: { aurelius_press_document_page: new_attributes }
        aurelius_press_page.reload
        expect(aurelius_press_page.title).to eq("The New Title")
      end

      it "redirects to the page" do
        patch aurelius_press_page_path(aurelius_press_page), params: { aurelius_press_document_page: new_attributes }
        aurelius_press_page.reload
        expect(response).to redirect_to(aurelius_press_page_path(aurelius_press_page))
      end
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "DELETE /pages/:slug" do
    it "destroys the requested page" do
      expect {
        delete aurelius_press_page_path(aurelius_press_page)
      }.to change(AureliusPress::Document::Page, :count).by(-1)
    end

    it "redirects to the pages list" do
      delete aurelius_press_page_path(aurelius_press_page)
      expect(response).to redirect_to(aurelius_press_pages_path)
    end
  end
end
