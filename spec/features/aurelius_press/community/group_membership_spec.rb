require "rails_helper"

RSpec.feature "User can join and leave Groups", :js do
  let!(:user)    { create(:aurelius_press_user) }
  let!(:creator) { create(:aurelius_press_user) }
  let!(:group) do
    create(:aurelius_press_community_group,
           name: "Test Discussion Group",
           description: "A group for testing.",
           creator: creator,
           privacy_setting: :public_group)
  end

  # ── JOIN ──────────────────────────────────────────────────────────────────

  scenario "JOIN - authenticated user can join a public group" do
    sign_in user
    visit aurelius_press_community_group_path(group)

    expect(page).to have_button("Join Group")

    click_button "Join Group"

    expect(page).to have_button("Leave Group")
    expect(AureliusPress::Community::GroupMembership.exists?(user: user, group: group)).to be true
  end

  scenario "JOIN - guest is redirected to sign in" do
    visit aurelius_press_community_group_path(group)

    expect(page).not_to have_button("Join Group")
    expect(page).not_to have_button("Leave Group")
  end

  # ── LEAVE ─────────────────────────────────────────────────────────────────

  scenario "LEAVE - member can leave a group" do
    membership = create(:aurelius_press_community_group_membership, user: user, group: group)

    sign_in user
    visit aurelius_press_community_group_path(group)

    expect(page).to have_button("Leave Group")

    accept_turbo_confirm do
      click_button "Leave Group"
    end

    expect(page).to have_button("Join Group")
    expect(AureliusPress::Community::GroupMembership.exists?(membership.id)).to be false
  end

  # ── MEMBER COUNT ──────────────────────────────────────────────────────────

  scenario "READ - group show page displays member count" do
    create(:aurelius_press_community_group_membership, user: user, group: group)
    create(:aurelius_press_community_group_membership, user: creator, group: group)

    sign_in user
    visit aurelius_press_community_group_path(group)

    expect(page).to have_content("Members (2)")
  end
end
