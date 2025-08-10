# spec/controllers/aurelius_press/admin/catalogue/quotes_controller_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Admin::Catalogue::QuotesController, type: :controller do
  render_views

  let!(:author) { create(:aurelius_press_catalogue_author) }
  let!(:source) { create(:aurelius_press_catalogue_source, authors: [author]) }
  let!(:admin) { create(:aurelius_press_admin_user) }

  before do
    sign_in admin
  end

  after do
    sign_out admin
  end

  # Define valid and invalid attributes for testing create/update actions
  let(:valid_attributes) do
    attributes_for(:aurelius_press_catalogue_quote,
                   source_id: source.id, # A quote must belong to a source
                   author_id: author.id # A quote must have an author
      )
  end

  let(:invalid_attributes) do
    attributes_for(:aurelius_press_catalogue_quote,
                   text: nil, # text is required
                   source_id: nil # source_id is required
      )
  end

  describe "GET #index" do
    it "returns a successful response and assigns @quotes" do
      # Create a quote with valid associations for the index test
      create(:aurelius_press_catalogue_quote, source: source)
      get :index
      expect(response).to be_successful
      expect(assigns(:quotes)).to_not be_nil
      expect(assigns(:quotes)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @quote" do
      quote = create(:aurelius_press_catalogue_quote, source: source)
      get :show, params: { id: quote.id }
      expect(response).to be_successful
      expect(assigns(:quote)).to eq(quote)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:quote)).to be_a_new(AureliusPress::Catalogue::Quote)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Quote" do
        expect {
          post :create, params: { aurelius_press_catalogue_quote: valid_attributes }
        }.to change(AureliusPress::Catalogue::Quote, :count).by(1)
      end

      it "redirects to the created quote" do
        post :create, params: { aurelius_press_catalogue_quote: valid_attributes }
        expect(response).to redirect_to(aurelius_press_admin_catalogue_quote_path(AureliusPress::Catalogue::Quote.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Quote" do
        expect {
          post :create, params: { aurelius_press_catalogue_quote: invalid_attributes }
        }.to_not change(AureliusPress::Catalogue::Quote, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_catalogue_quote: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @quote" do
      quote = create(:aurelius_press_catalogue_quote, source: source)
      get :edit, params: { id: quote.id }
      expect(response).to be_successful
      expect(assigns(:quote)).to eq(quote)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:quote_to_update) { create(:aurelius_press_catalogue_quote, source: source, text: "Old quote text") }
      let(:new_attributes) { { text: "New updated quote text" } }

      it "updates the requested quote" do
        patch :update, params: { id: quote_to_update.id, aurelius_press_catalogue_quote: new_attributes }
        quote_to_update.reload
        expect(quote_to_update.text).to eq("New updated quote text")
      end

      it "redirects to the quote" do
        patch :update, params: { id: quote_to_update.id, aurelius_press_catalogue_quote: new_attributes }
        quote_to_update.reload
        expect(response).to redirect_to(aurelius_press_admin_catalogue_quote_path(quote_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:quote_to_update) { create(:aurelius_press_catalogue_quote, source: source, text: "Valid quote text") }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: quote_to_update.id, aurelius_press_catalogue_quote: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the quote" do
        original_text = quote_to_update.text
        patch :update, params: { id: quote_to_update.id, aurelius_press_catalogue_quote: invalid_attributes }
        quote_to_update.reload
        expect(quote_to_update.text).to eq(original_text)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested quote" do
      quote = create(:aurelius_press_catalogue_quote, source: source)
      expect {
        delete :destroy, params: { id: quote.id }
      }.to change(AureliusPress::Catalogue::Quote, :count).by(-1)
    end

    it "redirects to the quotes list" do
      quote = create(:aurelius_press_catalogue_quote, source: source)
      delete :destroy, params: { id: quote.id }
      expect(response).to redirect_to(aurelius_press_admin_catalogue_quotes_url)
    end
  end
end
