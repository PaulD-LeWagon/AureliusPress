# == Schema Information
#
# Table name: aurelius_press_authorships
#
#  id         :bigint           not null, primary key
#  author_id  :bigint           not null
#  source_id  :bigint           not null
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
