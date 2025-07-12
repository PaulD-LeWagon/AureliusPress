class CreateContentBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :content_blocks do |t|
      t.references :document, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
