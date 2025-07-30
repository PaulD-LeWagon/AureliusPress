class AddStatusColumnToAureliusPressUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :aurelius_press_users, :status, :integer, default: 0, null: false
  end
end
