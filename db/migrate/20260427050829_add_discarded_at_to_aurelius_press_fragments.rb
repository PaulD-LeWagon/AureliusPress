class AddDiscardedAtToAureliusPressFragments < ActiveRecord::Migration[7.2]
  def change
    add_column :aurelius_press_fragments, :discarded_at, :datetime
    add_index :aurelius_press_fragments, :discarded_at
  end
end
