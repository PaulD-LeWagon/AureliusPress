class CreateAureliusPressGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :aurelius_press_groups do |t|
      t.string :slug, null: false, index: { unique: true }
      t.string :name, null: false, index: { unique: true }
      t.text :description

      # Foreign key to the newly namespaced 'aurelius_press_users' table
      t.references :creator, null: false, foreign_key: { to_table: :aurelius_press_users }

      t.integer :status, default: 0, null: false
      t.integer :privacy_setting, default: 0, null: false

      t.timestamps
    end
  end
end
