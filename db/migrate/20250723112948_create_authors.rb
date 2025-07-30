class CreateAuthors < ActiveRecord::Migration[7.2]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :bio

      t.timestamps
    end
    add_index :authors, :slug, unique: true
  end
end
