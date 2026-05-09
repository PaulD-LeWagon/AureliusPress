require "rails_helper"

RSpec.describe "AureliusPress::Admin::Taxonomy::Categories", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:category) { create(:aurelius_press_taxonomy_category) }
  let(:turbo_headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  before { sign_in admin }

  describe "GET /aurelius-press/admin/taxonomy/categories" do
    it "returns http success" do
      get aurelius_press_admin_taxonomy_categories_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /aurelius-press/admin/taxonomy/categories/:id" do
    it "destroys the category and redirects" do
      category_to_delete = create(:aurelius_press_taxonomy_category)
      expect {
        delete aurelius_press_admin_taxonomy_category_path(category_to_delete)
      }.to change(AureliusPress::Taxonomy::Category, :count).by(-1)
      expect(response).to redirect_to(aurelius_press_admin_taxonomy_categories_url)
    end

    context "with Turbo Stream format" do
      it "responds with turbo_stream media type" do
        delete aurelius_press_admin_taxonomy_category_path(category), headers: turbo_headers
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "returns http success" do
        delete aurelius_press_admin_taxonomy_category_path(category), headers: turbo_headers
        expect(response).to have_http_status(:ok)
      end

      it "destroys the category" do
        category
        expect {
          delete aurelius_press_admin_taxonomy_category_path(category), headers: turbo_headers
        }.to change(AureliusPress::Taxonomy::Category, :count).by(-1)
      end
    end
  end
end
