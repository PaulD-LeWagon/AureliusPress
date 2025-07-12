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

ActiveRecord::Schema[7.2].define(version: 2025_07_12_201701) do
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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "content_blocks", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "html_id"
    t.string "html_class"
    t.jsonb "data_attributes", default: {}
    t.index ["document_id"], name: "index_content_blocks_on_document_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.string "slug"
    t.text "description"
    t.datetime "published_at"
    t.integer "status"
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.integer "visibility"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_documents_on_category_id"
    t.index ["slug"], name: "index_documents_on_slug", unique: true
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "gallery_blocks", force: :cascade do |t|
    t.bigint "content_block_id", null: false
    t.integer "layout_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_block_id"], name: "index_gallery_blocks_on_content_block_id"
  end

  create_table "image_blocks", force: :cascade do |t|
    t.bigint "content_block_id", null: false
    t.string "caption"
    t.integer "alignment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_block_id"], name: "index_image_blocks_on_content_block_id"
  end

  create_table "rich_text_blocks", force: :cascade do |t|
    t.bigint "content_block_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_block_id"], name: "index_rich_text_blocks_on_content_block_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_taggings_on_document_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.integer "age"
    t.integer "role"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "video_embed_blocks", force: :cascade do |t|
    t.bigint "content_block_id", null: false
    t.text "embed_code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_block_id"], name: "index_video_embed_blocks_on_content_block_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "users"
  add_foreign_key "content_blocks", "documents"
  add_foreign_key "documents", "categories"
  add_foreign_key "documents", "users"
  add_foreign_key "gallery_blocks", "content_blocks"
  add_foreign_key "image_blocks", "content_blocks"
  add_foreign_key "rich_text_blocks", "content_blocks"
  add_foreign_key "taggings", "documents"
  add_foreign_key "taggings", "tags"
  add_foreign_key "video_embed_blocks", "content_blocks"
end
