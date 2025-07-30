class CreateAureliusPressGroupsDocumentsJoinTable < ActiveRecord::Migration[7.2]
  def change
    # Explicitly create the join table with its exact name
    create_table :aurelius_press_documents_aurelius_press_groups, id: false do |t|
      # Manually define the foreign key columns (bigint because IDs are bigints)
      t.bigint :aurelius_press_group_id, null: false
      t.bigint :aurelius_press_document_id, null: false

      t.timestamps # Optional, but good practice for tracking when associations were made
    end

    # Add indexes manually after table creation
    add_index :aurelius_press_documents_aurelius_press_groups, [:aurelius_press_group_id, :aurelius_press_document_id], unique: true, name: "idx_ap_groups_docs_unique"
    add_index :aurelius_press_documents_aurelius_press_groups, [:aurelius_press_document_id, :aurelius_press_group_id], name: "idx_ap_docs_groups"

    # Add foreign key constraints after table and indexes are set up
    add_foreign_key :aurelius_press_documents_aurelius_press_groups, :aurelius_press_groups
    add_foreign_key :aurelius_press_documents_aurelius_press_groups, :aurelius_press_documents
  end
end
