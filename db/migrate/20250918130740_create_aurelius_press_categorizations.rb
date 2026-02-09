class CreateAureliusPressCategorizations < ActiveRecord::Migration[7.2]
  def change
    create_table :aurelius_press_categorizations do |t|
      t.references :category, null: false, foreign_key: { to_table: :aurelius_press_categories }
      t.references :categorizable, polymorphic: true, null: false

      t.timestamps
    end
    add_index :aurelius_press_categorizations, [:categorizable_id, :categorizable_type, :category_id], unique: true, name: "idx_categorizables_on_category_and_type"
  end
end
