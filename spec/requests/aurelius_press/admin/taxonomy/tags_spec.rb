require "rails_helper"

RSpec.describe "AureliusPress::Admin::Taxonomy::Tags", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:tag) { create(:aurelius_press_taxonomy_tag) }
  let(:turbo_headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  before { sign_in admin }

  describe "GET /aurelius-press/admin/taxonomy/tags" do
    it "returns http success" do
      get aurelius_press_admin_taxonomy_tags_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /aurelius-press/admin/taxonomy/tags/:id" do
    it "destroys the tag and redirects" do
      tag_to_delete = create(:aurelius_press_taxonomy_tag)
      expect {
        delete aurelius_press_admin_taxonomy_tag_path(tag_to_delete)
      }.to change(AureliusPress::Taxonomy::Tag, :count).by(-1)
      expect(response).to redirect_to(aurelius_press_admin_taxonomy_tags_url)
    end

    context "with Turbo Stream format" do
      it "responds with turbo_stream media type" do
        delete aurelius_press_admin_taxonomy_tag_path(tag), headers: turbo_headers
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "returns http success" do
        delete aurelius_press_admin_taxonomy_tag_path(tag), headers: turbo_headers
        expect(response).to have_http_status(:ok)
      end

      it "destroys the tag" do
        tag
        expect {
          delete aurelius_press_admin_taxonomy_tag_path(tag), headers: turbo_headers
        }.to change(AureliusPress::Taxonomy::Tag, :count).by(-1)
      end
    end
  end
end
