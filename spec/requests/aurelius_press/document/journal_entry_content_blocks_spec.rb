require "rails_helper"

RSpec.describe "JournalEntry ContentBlocks", type: :request do
  let(:owner) { create(:aurelius_press_user) }
  let!(:entry) { create(:aurelius_press_document_journal_entry, user: owner) }
  let(:rich_text_block_attributes) do
    {
      "0" => {
        position: 1,
        contentable_type: "AureliusPress::ContentBlock::RichTextBlock",
        contentable_attributes: { content: "My journal thought." }
      }
    }
  end

  describe "PATCH /aurelius-press/journal-entries/:id (update with content blocks)" do
    context "when authenticated as owner" do
      before { sign_in owner }

      it "creates a nested content block" do
        expect {
          patch aurelius_press_journal_entry_path(entry),
                params: {
                  aurelius_press_document_journal_entry: {
                    content_blocks_attributes: rich_text_block_attributes
                  }
                }
        }.to change(AureliusPress::ContentBlock::ContentBlock, :count).by(1)
      end

      it "associates the content block with the journal entry" do
        patch aurelius_press_journal_entry_path(entry),
              params: {
                aurelius_press_document_journal_entry: {
                  content_blocks_attributes: rich_text_block_attributes
                }
              }
        expect(entry.reload.content_blocks.count).to eq(1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        patch aurelius_press_journal_entry_path(entry),
              params: {
                aurelius_press_document_journal_entry: {
                  content_blocks_attributes: rich_text_block_attributes
                }
              }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
