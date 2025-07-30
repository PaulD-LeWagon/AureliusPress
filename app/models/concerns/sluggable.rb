module Sluggable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_source_attribute, default: :name
    # Add a class_attribute to store the attribute that should be watched for changes.
    # This defaults to the same as slug_source_attribute if 'watches' is not provided.
    class_attribute :slug_attribute_for_dirty_check, default: :name

    before_validation :set_and_parameterize_slug_if_needed, on: [:create, :update]

    before_validation :ensure_slug_uniqueness, on: [:create, :update]

    validates :slug,
      presence: true,
      uniqueness: { case_sensitive: true }
  end

  module ClassMethods
    def slugged_by(attribute, options = {})
      self.slug_source_attribute = attribute
      # If 'watches' is provided in options, use it. Otherwise, default to the main attribute.
      self.slug_attribute_for_dirty_check = options[:watches] || attribute
    end
  end

  private

  # This method will handle setting the initial slug (if blank)
  # or re-parameterizing it if it's changed, OR if the source changed.
  def set_and_parameterize_slug_if_needed
    # Ensure source_value is always a string before sending to parameterize
    source_value = send(slug_source_attribute).to_s

    # Determine which attribute to actually check for changes.
    # This will be `text` for Quote (because we set `watches: :text`),
    # and the `slug_source_attribute` (e.g., `name`) for other models.
    attribute_to_watch_for_changes = self.slug_attribute_for_dirty_check
    source_has_changed = send("#{attribute_to_watch_for_changes}_changed?")

    # Condition 1: Slug is blank (new record, or explicitly blanked out)
    if self.slug.blank?
      self.slug = source_value.parameterize if source_value.present?
      # Condition 2: Slug was explicitly changed by user
    elsif slug_changed?
      self.slug = self.slug.parameterize
      # Condition 3: The attribute we are watching for changes has changed,
      # AND the current slug does NOT match the new parameterized source.
      # This covers cases where slug was originally derived from source, and source changed.
      # ---------------------------------------------------------------
      # Note: BUT WHAT IF THE SLUG IS ALREADY SET WITH A CUSTOM VALUE? |
      # ---------------------------------------------------------------
    elsif source_has_changed && self.slug != source_value.parameterize
      self.slug = source_value.parameterize
    end
    # Return the slug even if still blank, so it can be used in validations.
    # A random slug for, say, a new Quote without text or a category without a
    # name makes absolutely no sense.
    self.slug
  end

  # This method ensures the currently set slug is unique.
  # It will append a counter if a duplicate is found.
  def ensure_slug_uniqueness
    # Only run if a slug has been set by previous callbacks or explicitly by user.
    return unless self.slug.present?
    # Use the current slug as the base for uniqueness
    base_slug = self.slug
    candidate_slug = base_slug
    counter = 0
    # Loop to find a unique slug
    while self.class.where(slug: candidate_slug).where.not(id: self.id).exists?
      counter += 1
      candidate_slug = "#{base_slug}-#{counter}"
    end
    self.slug = candidate_slug
  end
end

# module Sluggable
#   extend ActiveSupport::Concern

#   included do
#     class_attribute :slug_source_attribute, default: :name

#     before_validation :set_and_parameterize_slug_if_needed, on: [:create, :update]

#     before_validation :ensure_slug_uniqueness, on: [:create, :update]

#     validates :slug,
#       presence: true,
#       uniqueness: { case_insensitive: true }
#   end

#   module ClassMethods
#     def slugged_by(attribute)
#       self.slug_source_attribute = attribute
#     end
#   end

#   private
#   # This method will handle setting the initial slug (if blank)
#   # or re-parameterizing it if it's changed, OR if the source changed.
#   def set_and_parameterize_slug_if_needed
#     source_value = send(slug_source_attribute).to_s
#     # Condition 1: Slug is blank (new record, or explicitly blanked out)
#     if self.slug.blank?
#       self.slug = source_value.parameterize if source_value.present?
#       # If source is also blank, slug remains blank, which will trigger presence validation.
#       # Condition 2: Slug was explicitly changed by user
#     elsif slug_changed?
#       self.slug = self.slug.parameterize
#       # Condition 3: Source attribute changed, and current slug does NOT match the new parameterized source.
#       # This covers cases where slug was originally derived from source, and source changed.
#     elsif send("#{slug_source_attribute}_changed?") && self.slug != source_value.parameterize
#       self.slug = source_value.parameterize
#     end
#   end
#   # This method ensures the currently set slug is unique.
#   # It will append a counter if a duplicate is found.
#   def ensure_slug_uniqueness
#     # Only run if a slug has been set by previous callbacks or explicitly by user.
#     return unless self.slug.present?
#     # Use the current slug as the base for uniqueness
#     base_slug = self.slug
#     candidate_slug = base_slug
#     counter = 0
#     # Loop to find a unique slug
#     while self.class.where(slug: candidate_slug).where.not(id: self.id).exists?
#       counter += 1
#       candidate_slug = "#{base_slug}-#{counter}"
#     end
#     self.slug = candidate_slug
#   end
# end
