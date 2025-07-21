class CreateRichTextBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :rich_text_blocks do |t|
      # Just a wraper for ActionText rich text content

      t.timestamps
    end
  end
end
