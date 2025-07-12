class CreateRichTextBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :rich_text_blocks do |t|
      t.references :content_block, null: false, foreign_key: true

      t.timestamps
    end
  end
end
