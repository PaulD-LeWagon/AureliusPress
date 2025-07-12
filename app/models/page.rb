# app/models/page.rb
class Page < Document
  # Callbacks
  after_initialize :set_default_visibility, if: :new_record?

  # Associations @see: Document
  # has_many :page_versions, dependent: :destroy

  # Validations @see: Document

  private

  def set_default_visibility
    self.visibility = :public_to_www
  end
end
