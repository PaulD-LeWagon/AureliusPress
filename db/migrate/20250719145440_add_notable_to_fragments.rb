class AddNotableToFragments < ActiveRecord::Migration[7.2]
  def change
    add_reference :fragments, :notable, polymorphic: true, null: true
  end
end
