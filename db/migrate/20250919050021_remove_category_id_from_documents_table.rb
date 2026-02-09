class RemoveCategoryIdFromDocumentsTable < ActiveRecord::Migration[7.2]
  def change
    remove_column :aurelius_press_documents, :category_id, :bigint
  end
end
