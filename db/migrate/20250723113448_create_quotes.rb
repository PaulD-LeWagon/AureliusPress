class CreateQuotes < ActiveRecord::Migration[7.2]
  def change
    create_table :quotes do |t|
      t.text :text
      t.string :context
      t.references :source, null: false, foreign_key: true
      t.references :original_quote, null: true, foreign_key: { to_table: :quotes }
      t.string :slug

      t.timestamps
    end
    add_index :quotes, :slug, unique: true
  end
end
