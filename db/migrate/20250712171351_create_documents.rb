class CreateDocuments < ActiveRecord::Migration[7.2]
  def change
    create_table :documents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, foreign_key: true
      t.string :type, null: false
      t.string :slug, null: false
      t.string :title, null: false
      t.string :subtitle
      t.text :description
      t.integer :status, null: false, default: 0
      t.integer :visibility, null: false, default: 0
      t.datetime :published_at

      t.timestamps
    end

    add_index :documents, :slug, unique: true
  end
end
