# frozen_string_literal: true

class LogoComponent < ApplicationComponent
  def initialize(src:, alt:, wrapper_class: "logo-wrap", html_options: {})
    @src = src
    @alt = alt
    @wrapper_class = wrapper_class
    @html_options = html_options
    super(html_options: @html_options)
  end

  def call
    content_tag("div", image_tag(@src, alt: @alt, class: @html_options[:class], **@html_options.except(:class)), class: @wrapper_class)
  end

  private

  def html_attributes
    default_classes = "img-logo-component dubhannaigh"
    combined_classes = [default_classes, @html_options[:class]].compact.join(" ")
    base_attributes = { class: combined_classes }
    @html_options.deep_merge(base_attributes)
  end
end
