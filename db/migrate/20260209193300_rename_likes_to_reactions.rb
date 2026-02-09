class RenameLikesToReactions < ActiveRecord::Migration[7.2]
  def change
    rename_table :aurelius_press_likes, :aurelius_press_reactions

    # Rename columns to match new domain concept
    rename_column :aurelius_press_reactions, :likeable_type, :reactable_type
    rename_column :aurelius_press_reactions, :likeable_id, :reactable_id

    # Rename indexes to reflect new table/column names (optional but good for consistency)
    # The default index renaming might happen automatically but let's be explicit if needed.
    # However, Rails usually handles index renames on column rename.
    # But custom named indexes might need manual rename.
    
    # Check original migration:
    # add_index :likes, [:user_id, :likeable_type, :likeable_id], unique: true, name: "idx_likes_unique_per_user_item"
    
    rename_index :aurelius_press_reactions, "idx_likes_unique_per_user_item", "idx_reactions_unique_per_user_item"
    
    # Also rename the standard polymorphic index if it has a default name
    # index_likes_on_likeable -> index_reactions_on_reactable
    # But since it was created with: add_index :likes, [:likeable_type, :likeable_id]
    # It likely has a name like `index_aurelius_press_likes_on_likeable_type_and_likeable_id`
    # Let's check schema.rb again to be sure of index names.
  end
end
