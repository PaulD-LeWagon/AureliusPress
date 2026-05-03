class CreateAureliusPressSiteSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :aurelius_press_site_settings do |t|
      t.string :key, null: false
      t.string :value
      t.string :value_type, null: false, default: "string"
      t.string :description

      t.timestamps
    end
    add_index :aurelius_press_site_settings, :key, unique: true
  end
end
