class CreateAffiliateLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :affiliate_links do |t|
      t.string :url
      t.string :text
      t.text :description
      t.references :linkable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
