require "rails_helper"

RSpec.describe "AureliusPress::Admin::Catalogue::Authors", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:author) { create(:aurelius_press_catalogue_author) }
  let(:category) { create(:aurelius_press_taxonomy_category) }
  let(:tag) { create(:aurelius_press_taxonomy_tag) }

  before do
    sign_in admin
  end

  describe "GET /aurelius-press/admin/catalogue/authors" do
    it "returns http success" do
      get "/aurelius-press/admin/catalogue/authors"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/catalogue/authors/:id" do
    it "returns http success" do
      get "/aurelius-press/admin/catalogue/authors/#{author.slug}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/catalogue/authors/new" do
    it "returns http success" do
      get "/aurelius-press/admin/catalogue/authors/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /aurelius-press/admin/catalogue/authors" do
    let(:valid_params) do
      {
        aurelius_press_catalogue_author: {
          name: "Marcus Aurelius",
          bio: "Roman Emperor and Stoic philosopher.",
          category_ids: [ category.id ],
          tag_ids: [ tag.id ]
        }
      }
    end

    it "creates a new author with taxonomy" do
      expect {
        post "/aurelius-press/admin/catalogue/authors", params: valid_params
      }.to change(AureliusPress::Catalogue::Author, :count).by(1)

      new_author = AureliusPress::Catalogue::Author.last
      expect(new_author.name).to eq("Marcus Aurelius")
      expect(new_author.categories).to include(category)
      expect(new_author.tags).to include(tag)
      expect(response).to redirect_to(aurelius_press_admin_catalogue_author_path(new_author))
    end
  end

  describe "GET /aurelius-press/admin/catalogue/authors/:id/edit" do
    it "returns http success" do
      get "/aurelius-press/admin/catalogue/authors/#{author.slug}/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /aurelius-press/admin/catalogue/authors/:id" do
    it "updates the author and redirects" do
      patch "/aurelius-press/admin/catalogue/authors/#{author.slug}", params: { aurelius_press_catalogue_author: { name: "Updated Name" } }
      expect(author.reload.name).to eq("Updated Name")
      expect(response).to redirect_to(aurelius_press_admin_catalogue_author_path(author))
    end
  end

  describe "DELETE /aurelius-press/admin/catalogue/authors/:id" do
    it "destroys the author and redirects" do
      author_to_delete = create(:aurelius_press_catalogue_author)
      expect {
        delete "/aurelius-press/admin/catalogue/authors/#{author_to_delete.slug}"
      }.to change(AureliusPress::Catalogue::Author, :count).by(-1)
      expect(response).to redirect_to(aurelius_press_admin_catalogue_authors_path)
    end
  end
end
