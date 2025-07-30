class AureliusPress::Catalogue::AffiliateLink < ApplicationRecord
  self.table_name = "aurelius_press_affiliate_links"
  belongs_to :linkable, polymorphic: true
  # Validations
  validates :text, presence: true
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }
  validates :linkable, presence: true
end
