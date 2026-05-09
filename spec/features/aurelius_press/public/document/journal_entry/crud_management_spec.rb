require "rails_helper"

RSpec.feature "User can manage their Journal Entries (CRUD)", :js do
  let!(:user)       { create(:aurelius_press_user) }
  let!(:other_user) { create(:aurelius_press_user) }
  let!(:entry_one) do
    create(:aurelius_press_document_journal_entry,
           title: "My First Entry",
           description: "Reflections on the day.",
           user: user)
  end
  let!(:entry_two) do
    create(:aurelius_press_document_journal_entry,
           title: "Second Thoughts",
           description: "More reflections.",
           user: user)
  end

  # ── CREATE ────────────────────────────────────────────────────────────────

  scenario "CREATE - authenticated user can create a journal entry" do
    sign_in user
    visit new_aurelius_press_journal_entry_path

    fill_in "Title", with: "A New Journal Entry"
    fill_in "Description", with: "Today I learned something new."
    select "Published", from: "Status"

    click_button "Create"

    expect(page).to have_content("Journal entry created.")
    expect(page).to have_content("A New Journal Entry")
    expect(page).to have_content("Today I learned something new.")
  end

  scenario "CREATE - guest is redirected to sign in" do
    visit new_aurelius_press_journal_entry_path
    expect(page).to have_current_path(new_user_session_path)
  end

  # ── READ ──────────────────────────────────────────────────────────────────

  scenario "READ - authenticated user can view their own journal index" do
    sign_in user
    visit aurelius_press_journal_entries_path

    expect(page).to have_content("My Journal")
    expect(page).to have_content(entry_one.title)
    expect(page).to have_content(entry_two.title)
  end

  scenario "READ - another user cannot see someone else's entries" do
    sign_in other_user
    visit aurelius_press_journal_entries_path

    expect(page).not_to have_content(entry_one.title)
    expect(page).not_to have_content(entry_two.title)
  end

  scenario "READ - user can view a single journal entry" do
    sign_in user
    visit aurelius_press_journal_entry_path(entry_one)

    expect(page).to have_content(entry_one.title)
    expect(page).to have_content(entry_one.description)
  end

  scenario "READ - another user is forbidden from viewing someone else's entry" do
    sign_in other_user
    visit aurelius_press_journal_entry_path(entry_one)

    expect(page).not_to have_current_path(aurelius_press_journal_entry_path(entry_one))
  end

  # ── UPDATE ────────────────────────────────────────────────────────────────

  scenario "UPDATE - user can edit their own journal entry" do
    sign_in user
    visit edit_aurelius_press_journal_entry_path(entry_one)

    fill_in "Title", with: "Updated Title"
    click_button "Update"

    expect(page).to have_content("Journal entry updated.")
    expect(page).to have_content("Updated Title")
  end

  # ── DELETE ────────────────────────────────────────────────────────────────

  scenario "DELETE - user can delete their own journal entry" do
    sign_in user
    visit aurelius_press_journal_entry_path(entry_one)

    accept_turbo_confirm do
      click_link "Delete"
    end

    # Turbo Stream fires remove from show page; verify DB deletion and absence on index
    expect(AureliusPress::Document::JournalEntry.exists?(entry_one.id)).to be false
    visit aurelius_press_journal_entries_path
    expect(page).not_to have_content(entry_one.title)
  end

  # ── PRIVACY ENFORCEMENT ───────────────────────────────────────────────────

  scenario "PRIVACY - journal entries are always private (never public)" do
    sign_in user
    visit new_aurelius_press_journal_entry_path

    # The visibility field should not be present — JournalEntry is always private
    expect(page).not_to have_select("Visibility")
  end
end
