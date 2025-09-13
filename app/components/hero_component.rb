# frozen_string_literal: true

class HeroComponent < ApplicationComponent
  # This component represents a hero section, typically used for prominent content
  # at the top of a page, such as a welcome message or call to action.

  # @ TODO: make image optional
  # @ TODO: add support for background images
  # @ TODO: add support for CTA buttons or links

  # The HeroComponent allows you to specify:
  # - `level`: The heading level for the title (default is 1).
  # - `title`: The main title text.
  # - `subtitle`: A subtitle or description text.
  # - `src`: The source URL for the hero image.
  # - `alt`: Alternative text for the hero image.
  # - `img_class`: CSS class for the hero image (default is "hero-img").
  # - `css_class`: CSS class for the hero section (default is "hero-component").
  #
  # It inherits from ApplicationComponent, which provides common functionality
  # and HTML options handling.

  erb_template <<-ERB
    <div <%= html_attributes %>>
      <div class="container grid">
        <% if @src.present? %>
        <div class="hero-image-cont">
          <img src="<%= @src %>" alt="<%= @alt %>" class="<%= @img_class %>" />
        </div>
        <% end %>
        <hgroup class="hero-header-group">
          <h<%= @level %> class="title">
            <%= @title %>
          </h<%= @level %>>
          <p class="subtitle">
            <%= @subtitle %>
          </p>
          <%# This is where you can add a call to action (button/anchor) or %>
          <%# even additional content. %>
          <%= content if content %>
        </hgroup>
      </div>
    </div>
  ERB

  # Initialize the component with optional CSS class and HTML options.
  # The default CSS class is "hero-component".
  #
  # @param css_class [String] The CSS class to apply to the hero section.
  # @param html_options [Hash] Additional HTML attributes for the hero section.
  #   This can include data attributes, styles, and other HTML attributes.
  #
  # @example
  #   HeroComponent.new(css_class: "custom-hero", html_options: { data: { role: "banner" }, style: { backgroundColor: "blue" } })
  #
  # @return [HeroComponent] An instance of the HeroComponent.
  # @see ApplicationComponent#html_attributes for details on how HTML attributes are processed.
  # @see ApplicationComponent for common functionality shared across components.
  # @see https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div for more on the <div> element.
  #
  # @note The `html_options` parameter should be a Hash. If it is not, it will be converted to an empty Hash.
  #       This ensures that the component can handle cases where no HTML options are provided.
  # @note The `css_class` parameter defaults to "hero-component", but can be customized to apply specific styles.
  #       This allows for flexibility in styling the hero section without modifying. However, should you want to
  #       only augment the current styling, ensure to include the default class in your custom class string.
  #       For example, `css_class: "hero-component custom-class"` will apply both classes.

  attr_reader :level, :title, :subtitle, :small, :src, :alt, :img_class, :css_class, :html_options

  def initialize(
    level: 1,
    title: "",
    subtitle: "",
    small: false,
    css_class: "hero-component",
    src: "",
    alt: "",
    img_class: "hero-img",
    html_options: {}
  )
    css_class += " small" if small
    css_class += " flex justify-center items-center"
    @level = level
    @title = title
    @subtitle = subtitle
    @src = src
    @alt = alt
    @img_class = img_class
    @css_class = css_class
    @html_options = html_options.is_a?(Hash) ? html_options : {}
    super(css_class: css_class, html_options: html_options)
  end

  def html_attributes
    super
  end
end
