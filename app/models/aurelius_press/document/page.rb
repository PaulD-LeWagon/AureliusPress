# == Schema Information
#
# Table name: aurelius_press_documents
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  category_id      :bigint
#  type             :string           not null
#  slug             :string           not null
#  title            :string           not null
#  subtitle         :string
#  description      :text
#  status           :integer          default("draft"), not null
#  visibility       :integer          default("private_to_owner"), not null
#  published_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
class AureliusPress::Document::Page < AureliusPress::Document::Document
  # Associations @see: Document
  # @TODO: implement Document Versioning???
  # has_many :page_versions, dependent: :destroy

  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  # Validations @see: Document

  private

  def set_defaults
    self.visibility ||= :public_to_www
  end
end
