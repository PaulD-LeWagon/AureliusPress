class CreateAureliusPressLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :aurelius_press_likes do |t|
      t.references :user, null: false, foreign_key: { to_table: :aurelius_press_users }
      t.references :likeable, polymorphic: true, null: false
      t.integer :state, default: 0, null: false

      t.timestamps
    end

    add_index :aurelius_press_likes, [ :user_id, :likeable_type, :likeable_id ], unique: true, name: 'idx_ap_likes_unique_user_item'
  end
end
