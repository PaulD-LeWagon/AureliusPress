class CreateFragments < ActiveRecord::Migration[7.2]
  def change
    create_table :fragments do |t|
      t.string :type, null: false # For STI: 'Comment' or 'Note'
      t.references :user, null: false, foreign_key: true
      t.references :commentable, polymorphic: true, null: true # This creates commentable_id and commentable_type
      t.string :title, null: true, default: nil # Optional title for the fragment
      t.integer :position, null: false, default: 0 # For ordering fragments within a document
      t.integer :status, null: false, default: 0
      t.integer :visibility, null: false, default: 0

      t.timestamps
    end
  end
end
