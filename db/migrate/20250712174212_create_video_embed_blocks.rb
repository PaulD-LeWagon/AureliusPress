class CreateVideoEmbedBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :video_embed_blocks do |t|
      t.text :embed_code
      t.string :description

      t.timestamps
    end
  end
end
