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
