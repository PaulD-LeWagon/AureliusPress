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
class AureliusPress::Document::BlogPost < AureliusPress::Document::Document
  # Associations @see Document model for common associations
  # has_many :comments, dependent: :destroy
  # has_many :likes, dependent: :destroy
  # has_many :taggings, dependent: :destroy
  # has_many :categorizations, dependent: :destroy
  # has_many :tags (via Tagging join table - to be created later)
  # has_many :categories (via Categorization join table - to be created later)

  after_initialize :set_defaults, if: :new_record?

  validates :published_at, presence: true, if: :published?

  def published?
    published_at.present? && published_at <= Time.current
  end

  private

  def set_defaults
    self.visibility ||= :public_to_www
    self.published_at ||= Time.current if published?
  end
end
