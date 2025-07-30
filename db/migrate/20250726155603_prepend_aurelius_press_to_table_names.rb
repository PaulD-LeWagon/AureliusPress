class PrependAureliusPressToTableNames < ActiveRecord::Migration[7.2]
  def change
    # Renaming core application tables
    rename_table :users, :aurelius_press_users
    rename_table :categories, :aurelius_press_categories
    rename_table :documents, :aurelius_press_documents
    rename_table :fragments, :aurelius_press_fragments
    rename_table :likes, :aurelius_press_likes
    rename_table :tags, :aurelius_press_tags
    rename_table :taggings, :aurelius_press_taggings

    rename_table :authors, :aurelius_press_authors
    rename_table :authorships, :aurelius_press_authorships
    rename_table :quotes, :aurelius_press_quotes
    rename_table :sources, :aurelius_press_sources
    rename_table :affiliate_links, :aurelius_press_affiliate_links

    # Renaming ContentBlock related tables
    rename_table :content_blocks, :aurelius_press_content_blocks
    rename_table :image_blocks, :aurelius_press_image_blocks
    rename_table :rich_text_blocks, :aurelius_press_rich_text_blocks
    rename_table :gallery_blocks, :aurelius_press_gallery_blocks
    rename_table :video_embed_blocks, :aurelius_press_video_embed_blocks
  end
end
