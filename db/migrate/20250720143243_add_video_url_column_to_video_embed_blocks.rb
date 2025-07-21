class AddVideoUrlColumnToVideoEmbedBlocks < ActiveRecord::Migration[7.2]
  def change
    add_column :video_embed_blocks, :video_url, :string
  end
end
