class AureliusPress::Catalogue::Authorship < ApplicationRecord
  self.table_name = "aurelius_press_authorships"

  belongs_to :author, class_name: "AureliusPress::Catalogue::Author", inverse_of: :authorships
  belongs_to :source, class_name: "AureliusPress::Catalogue::Source", inverse_of: :authorships

  validates :source, presence: true
  validates :author, presence: true
  validates :author_id,
            uniqueness: {
              scope: :source_id,
              message: "this author is already associated with this source",
            }

  enum :role, %i[
    author
    co_author
    editor
    translator
    commentator
    compiler
    introducer
    contributor
  ]
end
