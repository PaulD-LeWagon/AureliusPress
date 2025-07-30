class DropBioColumnFromAureliusPressUsers < ActiveRecord::Migration[7.2]
  def change
    # Remove the bio column from the aurelius_press_users table
    remove_column :aurelius_press_users, :bio, :text
  end
end
