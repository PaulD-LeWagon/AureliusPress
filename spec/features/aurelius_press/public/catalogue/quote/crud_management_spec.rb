require "rails_helper"

RSpec.feature "Admins can moderate Notes (CRUD)", :js do
  # Users with different roles
  let!(:user) { create(:aurelius_press_user) }
  # Users with elevated permissions
  let!(:moderator) { create(:aurelius_press_moderator_user) }
  let!(:admin) { create(:aurelius_press_admin_user) }
  let!(:superuser) { create(:aurelius_press_superuser_user) }
  # Add to array for easy iteration in tests
  let!(:power_users) { [moderator, admin, superuser] }
  # Create a blog post to associate comments with
  let!(:blog_post) { create(:aurelius_press_document_blog_post) }
  # Create a comments to work with
  let!(:note_one) { create(:aurelius_press_fragment_note, notable: blog_post, user: user, content: "This is the first note.") }

  scenario "READ - Power Users can view a list of all notes" do
    power_users.each do |the_actor|
      # 1. Log in as a power user
      sign_in the_actor
      # 2. Navigate to the admin notes index page
      visit aurelius_press_admin_fragment_notes_path
      # 3. Verify that the power user can see the notes
      expect(page).to have_content("View Notes")
      expect(page).to have_css("[template=\"AureliusPress::Admin::Fragment::Notes#index\"]")
      # 4. Assert that both notes created by FactoryBot are visible
      expect(page).to have_content(note_one.content.body.to_plain_text.truncate(30))
      # 5. Sign out the user
      sign_out the_actor
    end
  end

  scenario "READ - Power Users can view a note for moderation" do
    power_users.each do |the_actor|
      # 1. Log in as a power user
      sign_in the_actor
      # 2. Navigate to the admin notes index page
      visit aurelius_press_admin_fragment_notes_path
      # 3. Click on the note to view its details
      click_link "View Details", href: aurelius_press_admin_fragment_note_path(note_one)
      # 4. Verify that we are in the correct view and the note details are visible
      expect(page).to have_css("[template=\"AureliusPress::Admin::Fragment::Notes#show\"]")
      expect(page).to have_content("Viewing Note")
      expect(page.text.squish).to include(note_one.content.body.to_plain_text.squish)
      # 5. Sign out the user
      sign_out the_actor
    end
  end

  # @TODO: UPDATE test is not needed until we switch from hard-delete to soft-delete

  scenario "DELETE - Power Users can delete a note" do
    power_users.each do |the_actor|
      # We're in a loop, REMEMBER!
      # So we need to ensure the state is reset for each iteration.
      # Hence, we recreate the notes if they were deleted in a prior iteration.
      # Clear out existing notes to ensure a clean state
      AureliusPress::Fragment::Note.destroy_all
      # Ensure we have two notes to start with
      note_one = create(:aurelius_press_fragment_note, notable: blog_post, user: user, content: "This is the first note.") if note_one.nil?
      note_two = create(:aurelius_press_fragment_note, notable: blog_post, user: user, content: "This is the second note.") if note_two.nil?

      note_text = note_one.content.body.to_plain_text
      # 1. Log in as a power user
      sign_in the_actor
      # 2. Navigate to the admin notes index page
      visit aurelius_press_admin_fragment_notes_path
      # 3. Verify that the admin sees a list of notes (both created by FactoryBot)
      expect(AureliusPress::Fragment::Note.count).to eq(2)
      # 4. Click on the note to view its details
      click_link "View Details", href: aurelius_press_admin_fragment_note_path(note_one)
      # 5. Verify that the note details are visible
      expect(page).to have_content("Viewing Note")
      expect(page.text.squish).to include(note_text.squish)
      # 6. Click the delete link for the first note and confirm
      accept_confirm do
        click_link "Delete", href: aurelius_press_admin_fragment_note_path(note_one)
      end
      # 7. Verify the note was deleted successfully
      expect(page).to have_content "Note deleted successfully."
      expect(page).to have_current_path(aurelius_press_admin_fragment_notes_path)
      expect(page.text.squish).not_to include(note_text.squish)
      expect(AureliusPress::Fragment::Note.count).to eq(1)
      # 8. Sign out the user
      sign_out the_actor
    end
  end
end
