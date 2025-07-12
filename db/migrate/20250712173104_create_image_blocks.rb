class CreateImageBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :image_blocks do |t|
      t.references :content_block, null: false, foreign_key: true
      t.string :caption
      t.integer :alignment

      t.timestamps
    end
  end
end
