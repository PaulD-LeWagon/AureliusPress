class DropBooksTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :books
  end

  def down
    create_table :books do |t|
      t.string :name
      t.string :slug
      t.integer :creator_id
      t.string :status
      t.string :privacy_setting
      t.string :alt_title
      t.timestamps
    end
  end
end
