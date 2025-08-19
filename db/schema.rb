# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_07_30_181443) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "aurelius_press_affiliate_links", force: :cascade do |t|
    t.string "url"
    t.string "text"
    t.text "description"
    t.string "linkable_type", null: false
    t.bigint "linkable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linkable_type", "linkable_id"], name: "index_affiliate_links_on_linkable"
  end

  create_table "aurelius_press_authors", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "comments_enabled", default: false, null: false
    t.index ["slug"], name: "index_aurelius_press_authors_on_slug", unique: true
  end

  create_table "aurelius_press_authorships", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "source_id", null: false
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_aurelius_press_authorships_on_author_id"
    t.index ["source_id"], name: "index_aurelius_press_authorships_on_source_id"
  end

  create_table "aurelius_press_categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_aurelius_press_categories_on_slug", unique: true
  end

  create_table "aurelius_press_content_blocks", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.string "contentable_type", null: false
    t.bigint "contentable_id", null: false
    t.integer "position", default: 0, null: false
    t.string "html_id"
    t.string "html_class"
    t.jsonb "data_attributes", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contentable_type", "contentable_id"], name: "idx_on_contentable_type_contentable_id_7a76fe5668"
    t.index ["contentable_type", "contentable_id"], name: "index_content_blocks_on_contentable"
    t.index ["document_id", "html_id"], name: "idx_content_blocks_on_document_id_html_id", unique: true, where: "(html_id IS NOT NULL)"
    t.index ["document_id"], name: "index_aurelius_press_content_blocks_on_document_id"
  end

  create_table "aurelius_press_documents", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id"
    t.string "type", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.string "subtitle"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.integer "visibility", default: 0, null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "comments_enabled", default: false, null: false
    t.index ["category_id"], name: "index_aurelius_press_documents_on_category_id"
    t.index ["slug"], name: "index_aurelius_press_documents_on_slug", unique: true
    t.index ["user_id"], name: "index_aurelius_press_documents_on_user_id"
  end

  create_table "aurelius_press_documents_aurelius_press_groups", id: false, force: :cascade do |t|
    t.bigint "aurelius_press_group_id", null: false
    t.bigint "aurelius_press_document_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aurelius_press_document_id", "aurelius_press_group_id"], name: "idx_ap_docs_groups"
    t.index ["aurelius_press_group_id", "aurelius_press_document_id"], name: "idx_ap_groups_docs_unique", unique: true
  end

  create_table "aurelius_press_fragments", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "user_id", null: false
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.string "title"
    t.integer "position", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "visibility", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notable_type"
    t.bigint "notable_id"
    t.index ["commentable_type", "commentable_id"], name: "index_fragments_on_commentable"
    t.index ["notable_type", "notable_id"], name: "index_fragments_on_notable"
    t.index ["user_id"], name: "index_aurelius_press_fragments_on_user_id"
  end

  create_table "aurelius_press_gallery_blocks", force: :cascade do |t|
    t.integer "layout_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aurelius_press_group_memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.bigint "invited_by_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "idx_aurelius_press_group_memberships_unique_group_user", unique: true
    t.index ["group_id"], name: "index_aurelius_press_group_memberships_on_group_id"
    t.index ["invited_by_id"], name: "index_aurelius_press_group_memberships_on_invited_by_id"
    t.index ["user_id"], name: "index_aurelius_press_group_memberships_on_user_id"
  end

  create_table "aurelius_press_groups", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.text "description"
    t.bigint "creator_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "privacy_setting", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_aurelius_press_groups_on_creator_id"
    t.index ["name"], name: "index_aurelius_press_groups_on_name", unique: true
    t.index ["slug"], name: "index_aurelius_press_groups_on_slug", unique: true
  end

  create_table "aurelius_press_image_blocks", force: :cascade do |t|
    t.string "caption"
    t.integer "alignment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link_text"
    t.string "link_title"
    t.string "link_class"
    t.string "link_target"
    t.string "link_url"
  end

  create_table "aurelius_press_likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.integer "emoji"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_aurelius_press_likes_on_likeable_type_and_likeable_id"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id", "likeable_type", "likeable_id"], name: "idx_likes_unique_per_user_item", unique: true
    t.index ["user_id"], name: "index_aurelius_press_likes_on_user_id"
  end

  create_table "aurelius_press_quotes", force: :cascade do |t|
    t.text "text"
    t.string "context"
    t.bigint "source_id", null: false
    t.bigint "original_quote_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "comments_enabled", default: false, null: false
    t.index ["original_quote_id"], name: "index_aurelius_press_quotes_on_original_quote_id"
    t.index ["slug"], name: "index_aurelius_press_quotes_on_slug", unique: true
    t.index ["source_id"], name: "index_aurelius_press_quotes_on_source_id"
  end

  create_table "aurelius_press_rich_text_blocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aurelius_press_sources", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "source_type"
    t.date "date"
    t.string "isbn"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "comments_enabled", default: false, null: false
    t.index ["slug"], name: "index_aurelius_press_sources_on_slug", unique: true
  end

  create_table "aurelius_press_taggings", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_aurelius_press_taggings_on_document_id"
    t.index ["tag_id"], name: "index_aurelius_press_taggings_on_tag_id"
  end

  create_table "aurelius_press_tags", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_aurelius_press_tags_on_slug", unique: true
  end

  create_table "aurelius_press_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.integer "age"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "status", default: 0, null: false
    t.index ["email"], name: "index_aurelius_press_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_aurelius_press_users_on_reset_password_token", unique: true
  end

  create_table "aurelius_press_video_embed_blocks", force: :cascade do |t|
    t.text "embed_code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
  end

  create_table "books", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "creator_id"
    t.string "status"
    t.string "privacy_setting"
    t.string "alt_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "aurelius_press_authorships", "aurelius_press_authors", column: "author_id"
  add_foreign_key "aurelius_press_authorships", "aurelius_press_sources", column: "source_id"
  add_foreign_key "aurelius_press_content_blocks", "aurelius_press_documents", column: "document_id"
  add_foreign_key "aurelius_press_documents", "aurelius_press_categories", column: "category_id"
  add_foreign_key "aurelius_press_documents", "aurelius_press_users", column: "user_id"
  add_foreign_key "aurelius_press_documents_aurelius_press_groups", "aurelius_press_documents"
  add_foreign_key "aurelius_press_documents_aurelius_press_groups", "aurelius_press_groups"
  add_foreign_key "aurelius_press_fragments", "aurelius_press_users", column: "user_id"
  add_foreign_key "aurelius_press_group_memberships", "aurelius_press_groups", column: "group_id"
  add_foreign_key "aurelius_press_group_memberships", "aurelius_press_users", column: "invited_by_id"
  add_foreign_key "aurelius_press_group_memberships", "aurelius_press_users", column: "user_id"
  add_foreign_key "aurelius_press_groups", "aurelius_press_users", column: "creator_id"
  add_foreign_key "aurelius_press_likes", "aurelius_press_users", column: "user_id"
  add_foreign_key "aurelius_press_quotes", "aurelius_press_quotes", column: "original_quote_id"
  add_foreign_key "aurelius_press_quotes", "aurelius_press_sources", column: "source_id"
  add_foreign_key "aurelius_press_taggings", "aurelius_press_documents", column: "document_id"
  add_foreign_key "aurelius_press_taggings", "aurelius_press_tags", column: "tag_id"
end
