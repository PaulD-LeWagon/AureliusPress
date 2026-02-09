class ConvertAureliusPressTaggingsToPolymorphic < ActiveRecord::Migration[7.2]
  def change
    # First, remove the old foreign key association.
    remove_reference :aurelius_press_taggings, :document, null: false, index: { unique: true }

    # Next, add the new polymorphic association.
    add_reference :aurelius_press_taggings, :taggable, polymorphic: true, null: false, index: true

    # Finally, add a unique index on the new polymorphic columns.
    add_index :aurelius_press_taggings, [:taggable_id, :taggable_type, :tag_id], unique: true, name: "idx_taggables_on_tag_and_type"
  end
end
