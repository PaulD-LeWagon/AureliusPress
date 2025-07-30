class CreateLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :likeable, polymorphic: true, null: false
      t.integer :emoji, null: true, default: nil

      t.timestamps
    end
    add_index :likes, [:user_id, :likeable_type, :likeable_id], unique: true, name: "idx_likes_unique_per_user_item"
    add_index :likes, [:likeable_type, :likeable_id]
  end
end
