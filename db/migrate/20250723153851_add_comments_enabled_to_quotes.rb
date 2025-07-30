class AddCommentsEnabledToQuotes < ActiveRecord::Migration[7.2]
  def change
    add_column :quotes, :comments_enabled, :boolean, null: false, default: false
  end
end
