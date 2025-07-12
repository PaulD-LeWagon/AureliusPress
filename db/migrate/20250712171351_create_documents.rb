class CreateDocuments < ActiveRecord::Migration[7.2]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :subtitle
      t.string :slug
      t.text :description
      t.datetime :published_at
      t.integer :status
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :visibility
      t.string :type

      t.timestamps
    end
    
    add_index :documents, :slug, unique: true
  end
end
