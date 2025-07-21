class AddColumCommentsEnabledToDocument < ActiveRecord::Migration[7.2]
  def change
    add_column :documents, :comments_enabled, :boolean, null: false, default: false
  end
end
