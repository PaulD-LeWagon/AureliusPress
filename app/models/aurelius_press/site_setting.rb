class AureliusPress::SiteSetting < ApplicationRecord
  self.table_name = "aurelius_press_site_settings"

  VALID_TYPES = %w[string boolean].freeze

  validates :key, presence: true, uniqueness: true
  validates :value_type, presence: true, inclusion: { in: VALID_TYPES }

  def typed_value
    case value_type
    when "boolean" then ActiveModel::Type::Boolean.new.cast(value)
    else value
    end
  end

  def self.get(key)
    record = find_by(key: key)
    record&.typed_value
  end

  def self.set(key, new_value)
    record = find_or_initialize_by(key: key)
    record.value_type ||= "string"
    record.value = new_value.to_s
    record.save!
  end
end
