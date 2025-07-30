class RemoveAuthorIdFromSources < ActiveRecord::Migration[7.2]
  def change
    remove_reference :sources, :author, null: false, foreign_key: true
  end
end
