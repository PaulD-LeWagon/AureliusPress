class AddHtmlAttributesToContentBlocks < ActiveRecord::Migration[7.2]
  def change
    add_column :content_blocks, :html_id, :string
    add_column :content_blocks, :html_class, :string
    add_column :content_blocks, :data_attributes, :jsonb, default: {}
  end
end
