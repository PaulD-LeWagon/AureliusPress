class CreateContentBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :content_blocks do |t|
      t.references :document, null: false, foreign_key: true
      t.references :contentable, polymorphic: true, null: false
      t.integer :position, null: false, default: 0
      t.string :html_id, null: true
      t.string :html_class
      t.jsonb :data_attributes, default: {}

      t.timestamps
    end
    add_index :content_blocks, [:contentable_type, :contentable_id]
    add_index :content_blocks, [:document_id, :html_id], unique: true,
                                                         name: "idx_content_blocks_on_document_id_html_id", # Recommended custom name
                                                         where: "html_id IS NOT NULL"
  end
end
