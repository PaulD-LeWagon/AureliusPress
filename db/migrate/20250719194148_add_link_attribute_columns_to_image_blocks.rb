class AddLinkAttributeColumnsToImageBlocks < ActiveRecord::Migration[7.2]
  def change
    add_column :image_blocks, :link_text, :string
    add_column :image_blocks, :link_title, :string
    add_column :image_blocks, :link_class, :string
    add_column :image_blocks, :link_target, :string
    add_column :image_blocks, :link_url, :string
  end
end
