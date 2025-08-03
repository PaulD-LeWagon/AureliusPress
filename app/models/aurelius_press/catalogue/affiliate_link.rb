# == Schema Information
#
# Table name: aurelius_press_affiliate_links
#
#  id            :bigint           not null, primary key
#  url           :string
#  text          :string
#  description   :text
#  linkable_type :string           not null
#  linkable_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class AureliusPress::Catalogue::AffiliateLink < ApplicationRecord
  self.table_name = "aurelius_press_affiliate_links"
  belongs_to :linkable, polymorphic: true
  # Validations
  validates :text, presence: true
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }
  validates :linkable, presence: true
end
