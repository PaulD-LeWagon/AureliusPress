class CreateGalleryBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :gallery_blocks do |t|
      t.references :content_block, null: false, foreign_key: true
      t.integer :layout_type

      t.timestamps
    end
  end
end
