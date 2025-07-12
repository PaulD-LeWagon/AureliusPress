class VideoEmbedBlock < ApplicationRecord
  belongs_to :content_block
  # Add validations for embed_code format/presence
  validates :embed_code, presence: true, format: { with: /\Ahttps?:\/\/(www\.)?youtube\.com\/watch\?v=[\w-]+\z/, message: "must be a valid YouTube URL" }

  # Additional methods or scopes can be added here as needed
  def video_id
    embed_code.split("v=").last.split("&").first if embed_code.present?
  end
end
