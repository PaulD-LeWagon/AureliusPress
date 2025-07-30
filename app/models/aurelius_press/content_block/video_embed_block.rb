class AureliusPress::ContentBlock::VideoEmbedBlock < ApplicationRecord
  self.table_name = "aurelius_press_video_embed_blocks"
  has_one :content_block, as: :contentable, touch: true, dependent: :destroy
  # Add validations for embed_code format/presence
  validates :content_block, presence: true
  # Ensure video_url is present for setting embed_code
  validates :video_url, presence: true
  # Custom validation to ensure the embed_code is a valid YouTube video URL
  validate :video_url_is_valid_youtube_video
  # Ensure embed_code is present
  validates :embed_code, presence: true

  # Callbacks
  before_validation :set_embed_code

  # Class methods
  # This method can be called directly on the class (e.g., VideoEmbedBlock.extract_youtube_video_id(url))
  # It extracts the 11-character video ID from both long and short YouTube URLs.
  def self.extract_youtube_video_id(url)
    # This regex handles various YouTube URL formats (watch, youtu.be, embed, v)
    # and specifically captures the 11-character video ID.
    match = url.to_s.match(/(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/)
    match[1] if match
  end

  # Instance methods
  # This is a convenience method to get the video ID for a specific
  # VideoEmbedBlock instance.
  def youtube_video_id
    self.class.extract_youtube_video_id(video_url)
  end

  private

  def set_embed_code
    # "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/#{youtube_video_id}\" frameborder=\"0\" allowfullscreen></iframe>"
    # Set the embed_code based on the video_url if it's not already set
    self.embed_code = youtube_video_id if embed_code.blank?
  end

  # Custom validation logic for embed_code
  def video_url_is_valid_youtube_video
    return if video_url.blank?
    # Just ensure a valid video ID can be extracted from the original URL.
    unless youtube_video_id.present?
      errors.add(:video_url, "must be a valid single YouTube video URL (e.g., https://www.youtube.com/watch?v=VIDEO_ID_11 or https://youtu.be/VIDEO_ID_11).")
    end
  end
end

# <% if video_embed_block.youtube_video_id.present? %>
#   <div class="video-embed-container">
#     <iframe
#       width="560"
#       height="315"
#       src="https://www.youtube.com/embed/<%= video_embed_block.youtube_video_id %>?rel=0"
#       frameborder="0"
#       allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
#       allowfullscreen
#     ></iframe>
#     <% if video_embed_block.caption.present? %>
#       <figcaption><%= video_embed_block.caption %></figcaption>
#     <% end %>
#   </div>
# <% end %>
