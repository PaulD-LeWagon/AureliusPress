require "rails_helper"

RSpec.describe AureliusPress::Admin::Fragment::NotesController, type: :controller do
  render_views

  let!(:moderator_user) { create(:aurelius_press_moderator_user) }
  let!(:user) { create(:aurelius_press_user) }

  before do
    sign_in moderator_user
  end

  after do
    sign_out moderator_user
  end

  # Attributes for direct record creation
  let(:record_attributes) {
    {
      user: user,
      content: "A quick thought about a new feature.",
    }
  }

  # Attributes for controller parameters
  let(:param_attributes) {
    {
      user_id: user.id,
      notable_id: create(:aurelius_press_document_blog_post).id,
      notable_type: "AureliusPress::Document::BlogPost",
      type: "AureliusPress::Fragment::Note",
      title: "New Feature Note",
      status: :draft,
      visibility: :private_to_owner,
      position: 1,
      content: "A note added via the form.",
    }
  }

  # Invalid attributes for controller parameters
  let(:invalid_param_attributes) {
    {
      user_id: user.id,
      content: "",
    }
  }

  describe "GET #index" do
    it "returns a successful response and assigns @notes" do
      create(:aurelius_press_fragment_note, record_attributes)
      get :index
      expect(response).to be_successful
      expect(assigns(:notes)).to_not be_nil
      expect(assigns(:notes)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #show" do
    it "returns a successful response and assigns @note" do
      note = create(:aurelius_press_fragment_note, record_attributes)
      get :show, params: { id: note.id }
      expect(response).to be_successful
      expect(assigns(:note)).to eq(note)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:note)).to be_a_new(AureliusPress::Fragment::Note)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Note" do
        expect {
          post :create, params: { aurelius_press_fragment_note: param_attributes }
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end

      it "redirects to the created note" do
        post :create, params: { aurelius_press_fragment_note: param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_fragment_note_path(AureliusPress::Fragment::Note.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Note" do
        expect {
          post :create, params: { aurelius_press_fragment_note: invalid_param_attributes }
        }.to_not change(AureliusPress::Fragment::Note, :count)
      end

      it "renders a response with 422 status (unprocessable_entity)" do
        post :create, params: { aurelius_press_fragment_note: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns @note" do
      note = create(:aurelius_press_fragment_note, record_attributes)
      get :edit, params: { id: note.id }
      expect(response).to be_successful
      expect(assigns(:note)).to eq(note)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let!(:note_to_update) { create(:aurelius_press_fragment_note, record_attributes) }
      let(:new_valid_param_attributes) { { content: "An updated thought." } }

      it "updates the requested note" do
        patch :update, params: { id: note_to_update.id, aurelius_press_fragment_note: new_valid_param_attributes }
        note_to_update.reload
        expect(note_to_update.content.to_plain_text).to eq(new_valid_param_attributes[:content])
        expect(note_to_update.content).to be_a(ActionText::RichText)
      end

      it "redirects to the note" do
        patch :update, params: { id: note_to_update.id, aurelius_press_fragment_note: new_valid_param_attributes }
        expect(response).to redirect_to(aurelius_press_admin_fragment_note_path(note_to_update))
      end
    end

    context "with invalid parameters" do
      let!(:note_to_update) { create(:aurelius_press_fragment_note, record_attributes) }

      it "renders a response with 422 status (unprocessable_entity)" do
        patch :update, params: { id: note_to_update.id, aurelius_press_fragment_note: invalid_param_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

      it "does not update the note" do
        original_body = note_to_update.content
        patch :update, params: { id: note_to_update.id, aurelius_press_fragment_note: invalid_param_attributes }
        note_to_update.reload
        expect(note_to_update.content).to eq(original_body)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested note" do
      note = create(:aurelius_press_fragment_note, record_attributes)
      expect {
        delete :destroy, params: { id: note.id }
      }.to change(AureliusPress::Fragment::Note, :count).by(-1)
    end

    it "redirects to the notes list" do
      note = create(:aurelius_press_fragment_note, record_attributes)
      delete :destroy, params: { id: note.id }
      expect(response).to redirect_to(aurelius_press_admin_fragment_notes_url)
    end
  end
end
