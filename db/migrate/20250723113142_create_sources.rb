class CreateSources < ActiveRecord::Migration[7.2]
  def change
    create_table :sources do |t|
      t.string :title
      t.text :description
      t.references :author, null: false, foreign_key: true
      t.integer :source_type
      t.date :date
      t.string :isbn
      t.string :slug

      t.timestamps
    end
    add_index :sources, :slug, unique: true
  end
end
