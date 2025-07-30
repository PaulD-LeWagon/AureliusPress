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
