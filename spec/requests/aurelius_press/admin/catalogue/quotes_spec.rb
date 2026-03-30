require "rails_helper"

RSpec.describe "AureliusPress::Admin::Catalogue::Quotes", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:source) { create(:aurelius_press_catalogue_source) }
  let(:quote) { create(:aurelius_press_catalogue_quote, source: source) }
  let(:category) { create(:aurelius_press_taxonomy_category) }
  let(:tag) { create(:aurelius_press_taxonomy_tag) }

  before do
    sign_in admin
  end

  describe "GET /aurelius-press/admin/catalogue/quotes" do
    it "returns http success" do
      get aurelius_press_admin_catalogue_quotes_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/catalogue/quotes/:id" do
    it "returns http success" do
      get aurelius_press_admin_catalogue_quote_path(quote)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/catalogue/quotes/new" do
    it "returns http success" do
      get new_aurelius_press_admin_catalogue_quote_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /aurelius-press/admin/catalogue/quotes" do
    let(:valid_params) do
      {
        aurelius_press_catalogue_quote: {
          text: "Death is a release from the impressions of the senses...",
          source_id: source.id,
          category_ids: [ category.id ],
          tag_ids: [ tag.id ]
        }
      }
    end

    it "creates a new quote with taxonomy" do
      expect {
        post aurelius_press_admin_catalogue_quotes_path, params: valid_params
      }.to change(AureliusPress::Catalogue::Quote, :count).by(1)

      new_quote = AureliusPress::Catalogue::Quote.last
      expect(new_quote.text).to include("Death is a release")
      expect(new_quote.categories).to include(category)
      expect(new_quote.tags).to include(tag)
      expect(response).to redirect_to(aurelius_press_admin_catalogue_quote_path(new_quote))
    end
  end

  describe "GET /aurelius-press/admin/catalogue/quotes/:id/edit" do
    it "returns http success" do
      get edit_aurelius_press_admin_catalogue_quote_path(quote)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /aurelius-press/admin/catalogue/quotes/:id" do
    it "updates the quote and redirects" do
      patch aurelius_press_admin_catalogue_quote_path(quote), params: { aurelius_press_catalogue_quote: { text: "Updated Text" } }
      expect(quote.reload.text).to eq("Updated Text")
      expect(response).to redirect_to(aurelius_press_admin_catalogue_quote_path(quote))
    end
  end

  describe "DELETE /aurelius-press/admin/catalogue/quotes/:id" do
    it "destroys the quote and redirects" do
      quote_to_delete = create(:aurelius_press_catalogue_quote)
      expect {
        delete aurelius_press_admin_catalogue_quote_path(quote_to_delete)
      }.to change(AureliusPress::Catalogue::Quote, :count).by(-1)
      expect(response).to redirect_to(aurelius_press_admin_catalogue_quotes_path)
    end
  end
end
