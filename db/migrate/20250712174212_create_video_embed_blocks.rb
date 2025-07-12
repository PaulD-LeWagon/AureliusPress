class CreateVideoEmbedBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :video_embed_blocks do |t|
      t.references :content_block, null: false, foreign_key: true
      t.text :embed_code
      t.string :description

      t.timestamps
    end
  end
end
