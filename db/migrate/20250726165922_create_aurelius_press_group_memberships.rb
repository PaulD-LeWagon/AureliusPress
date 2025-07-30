class CreateAureliusPressGroupMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :aurelius_press_group_memberships do |t|
      # Foreign keys to the newly namespaced groups and users tables
      t.references :group, null: false, foreign_key: { to_table: :aurelius_press_groups }
      t.references :user, null: false, foreign_key: { to_table: :aurelius_press_users }

      t.integer :role, default: 0, null: false
      t.integer :status, default: 0, null: false

      # Optional fields for invite/request workflow
      # Nullable foreign key for the user who sent the invite
      t.references :invited_by, foreign_key: { to_table: :aurelius_press_users }, null: true
      t.text :message, null: true # Optional message for invites/requests

      t.timestamps

      # Ensure a user can only have one membership (active or pending) per group
      t.index [:group_id, :user_id], unique: true, name: "idx_aurelius_press_group_memberships_unique_group_user"
    end
  end
end
