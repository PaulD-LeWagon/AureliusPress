require "rails_helper"

RSpec.describe "AureliusPress::Catalogue::Comments", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:valid_params) { { comment: { content: "A thoughtful comment." } } }

  # ── Author parent ──────────────────────────────────────────────────────────

  describe "POST /aurelius-press/catalogue/authors/:author_slug/comments" do
    let(:author) { create(:aurelius_press_catalogue_author) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a comment on the author" do
        expect {
          post aurelius_press_catalogue_author_comments_path(author), params: valid_params
        }.to change(AureliusPress::Fragment::Comment, :count).by(1)
      end

      it "associates the comment with the current user" do
        post aurelius_press_catalogue_author_comments_path(author), params: valid_params
        expect(AureliusPress::Fragment::Comment.last.user).to eq(owner)
      end

      it "redirects or returns turbo stream success" do
        post aurelius_press_catalogue_author_comments_path(author), params: valid_params
        expect(response).to have_http_status(:redirect).or have_http_status(:ok)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_catalogue_author_comments_path(author), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/catalogue/authors/:author_slug/comments/:id" do
    let(:author)    { create(:aurelius_press_catalogue_author) }
    let!(:comment)  { create(:aurelius_press_fragment_comment, user: owner, commentable: author) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the comment" do
        expect {
          delete aurelius_press_catalogue_author_comment_path(author, comment)
        }.to change(AureliusPress::Fragment::Comment, :count).by(-1)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the comment" do
        expect {
          delete aurelius_press_catalogue_author_comment_path(author, comment)
        }.not_to change(AureliusPress::Fragment::Comment, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_catalogue_author_comment_path(author, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── Source parent ──────────────────────────────────────────────────────────

  describe "POST /aurelius-press/catalogue/sources/:source_slug/comments" do
    let(:source) { create(:aurelius_press_catalogue_source) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a comment on the source" do
        expect {
          post aurelius_press_catalogue_source_comments_path(source), params: valid_params
        }.to change(AureliusPress::Fragment::Comment, :count).by(1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_catalogue_source_comments_path(source), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/catalogue/sources/:source_slug/comments/:id" do
    let(:source)   { create(:aurelius_press_catalogue_source) }
    let!(:comment) { create(:aurelius_press_fragment_comment, user: owner, commentable: source) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the comment" do
        expect {
          delete aurelius_press_catalogue_source_comment_path(source, comment)
        }.to change(AureliusPress::Fragment::Comment, :count).by(-1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_catalogue_source_comment_path(source, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── Quote parent ───────────────────────────────────────────────────────────

  describe "POST /aurelius-press/catalogue/quotes/:quote_slug/comments" do
    let(:quote) { create(:aurelius_press_catalogue_quote) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a comment on the quote" do
        expect {
          post aurelius_press_catalogue_quote_comments_path(quote), params: valid_params
        }.to change(AureliusPress::Fragment::Comment, :count).by(1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_catalogue_quote_comments_path(quote), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/catalogue/quotes/:quote_slug/comments/:id" do
    let(:quote)    { create(:aurelius_press_catalogue_quote) }
    let!(:comment) { create(:aurelius_press_fragment_comment, user: owner, commentable: quote) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the comment" do
        expect {
          delete aurelius_press_catalogue_quote_comment_path(quote, comment)
        }.to change(AureliusPress::Fragment::Comment, :count).by(-1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_catalogue_quote_comment_path(quote, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
