class AddCommentsEnabledToSources < ActiveRecord::Migration[7.2]
  def change
    add_column :sources, :comments_enabled, :boolean, null: false, default: false
  end
end
