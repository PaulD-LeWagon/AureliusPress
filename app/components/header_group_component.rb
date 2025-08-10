# frozen_string_literal: true
class HeaderGroupComponent < ApplicationComponent
  erb_template <<-ERB

  <hgroup <%= html_attributes %>>

    <h<%= @level %> class="title"><%= @title %></h<%= @level %>>

    <p class="subtitle"><%= @subtitle %></p>

  </hgroup>

  ERB

  attr_reader :level, :title, :subtitle

  # Initializes the HeaderGroupComponent with level, title, subtitle, CSS class, and HTML options.
  #
  # @param level [Integer] The heading level (default is 1).
  # @param title [String] The main title of the header group.
  # @param subtitle [String] The subtitle of the header group.
  # @param css_class [String] Additional CSS classes for styling.
  # @param html_options [Hash] Additional HTML attributes for the hgroup element.
  #
  # @example
  #   HeaderGroupComponent.new(level: 2, title: "Main Title", subtitle: "Subtitle", css_class: "custom-class")
  #
  # @return [HeaderGroupComponent] An instance of the component.
  # # @see ApplicationComponent
  # # @see https://guides.rubyonrails.org/action_view_overview.html#components
  # # @see https://api.rubyonrails.org/classes/ActionView/Component.html

  def initialize(level: 1, title: "", subtitle: "", css_class: "", html_options: {})
    super(css_class: "header-group #{css_class}", html_options: html_options)
    @level = level
    @title = title
    @subtitle = subtitle
  end

  # Returns the HTML attributes for the hgroup element, including CSS classes
  # and any additional options.
  #
  # @return [String] The HTML attributes string for the hgroup element.
  def html_attributes
    super
  end

  # Merges additional hashes into the existing retHash.
  def merge_hashes(retHash, *args)
    super(retHash, *args)
  end
end
