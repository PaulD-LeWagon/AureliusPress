class AureliusPress::Document::JournalEntry < AureliusPress::Document::Document
  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  # Validations @see: Document

  private

  def set_defaults
    self.visibility ||= :private_to_owner
    self.published_at ||= Time.current if published?
  end
end
