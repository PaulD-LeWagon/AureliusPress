class AddPartialUniqueIndexToContentBlocks < ActiveRecord::Migration[7.2]
  def change
    # Drop the old index
    remove_index :aurelius_press_content_blocks, column: [:document_id, :html_id]

    # Add a new partial unique index that excludes blank and NULL values
    add_index :aurelius_press_content_blocks,
              [:document_id, :html_id],
              unique: true,
              name: "idx_aurelius_press_content_blocks_on_document_id_html_id",
              where: "html_id IS NOT NULL AND html_id != ''"
  end
end
