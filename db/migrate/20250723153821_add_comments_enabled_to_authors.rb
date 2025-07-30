class AddCommentsEnabledToAuthors < ActiveRecord::Migration[7.2]
  def change
    add_column :authors, :comments_enabled, :boolean, null: false, default: false
  end
end
