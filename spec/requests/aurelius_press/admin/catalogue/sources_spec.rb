require "rails_helper"

RSpec.describe "AureliusPress::Admin::Catalogue::Sources", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:source) { create(:aurelius_press_catalogue_source) }
  let(:category) { create(:aurelius_press_taxonomy_category) }
  let(:tag) { create(:aurelius_press_taxonomy_tag) }

  before do
    sign_in admin
  end

  describe "GET /aurelius-press/admin/catalogue/sources" do
    it "returns http success" do
      get aurelius_press_admin_catalogue_sources_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/catalogue/sources/:id" do
    it "returns http success" do
      get aurelius_press_admin_catalogue_source_path(source)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/catalogue/sources/new" do
    it "returns http success" do
      get new_aurelius_press_admin_catalogue_source_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /aurelius-press/admin/catalogue/sources" do
    let(:valid_params) do
      {
        aurelius_press_catalogue_source: {
          title: "Meditations",
          description: "Personal writings of Marcus Aurelius.",
          source_type: "book",
          date: Date.today,
          category_ids: [ category.id ],
          tag_ids: [ tag.id ]
        }
      }
    end

    it "creates a new source with taxonomy" do
      expect {
        post aurelius_press_admin_catalogue_sources_path, params: valid_params
      }.to change(AureliusPress::Catalogue::Source, :count).by(1)

      new_source = AureliusPress::Catalogue::Source.last
      expect(new_source.title).to eq("Meditations")
      expect(new_source.categories).to include(category)
      expect(new_source.tags).to include(tag)
      expect(response).to redirect_to(aurelius_press_admin_catalogue_source_path(new_source))
    end
  end

  describe "GET /aurelius-press/admin/catalogue/sources/:id/edit" do
    it "returns http success" do
      get edit_aurelius_press_admin_catalogue_source_path(source)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /aurelius-press/admin/catalogue/sources/:id" do
    it "updates the source and redirects" do
      patch aurelius_press_admin_catalogue_source_path(source), params: { aurelius_press_catalogue_source: { title: "Updated Title" } }
      expect(source.reload.title).to eq("Updated Title")
      expect(response).to redirect_to(aurelius_press_admin_catalogue_source_path(source))
    end
  end

  describe "DELETE /aurelius-press/admin/catalogue/sources/:id" do
    it "destroys the source and redirects" do
      source_to_delete = create(:aurelius_press_catalogue_source)
      expect {
        delete aurelius_press_admin_catalogue_source_path(source_to_delete)
      }.to change(AureliusPress::Catalogue::Source, :count).by(-1)
      expect(response).to redirect_to(aurelius_press_admin_catalogue_sources_path)
    end
  end
end
