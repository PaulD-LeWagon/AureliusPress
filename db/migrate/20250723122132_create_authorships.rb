class CreateAuthorships < ActiveRecord::Migration[7.2]
  def change
    create_table :authorships do |t|
      t.references :author, null: false, foreign_key: true
      t.references :source, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
