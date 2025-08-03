# frozen_string_literal: true

class AccordionComponent < ApplicationComponent

  # AccordionComponent is a component for creating an accordion-style UI element.
  # It allows for multiple items, each with a title and content, The component can
  # be customized with CSS classes and HTML options.
  # e.g.
  #   <%= render AccordionComponent.new(
  #     css_class: "my-accordion",
  #     items: [
  #       {
  #         is_button: true,
  #         the_title: "The Vixen",
  #         the_content: "The quick brown fox, jumped over the lazy dog!"
  #       },
  #       {
  #         is_button: true,
  #         title_class: 'secondary outline',
  #         content_class: 'accordian-content',
  #         item_class: "custom-accordian-item-class"
  #         the_title: "The Dog",
  #         the_content: "The lazy dog slept on the doorstep while the fox was about her business!"
  #       }
  #     ],
  #     html_options: { data: { controller: "accordion" } }
  #   ) %>
  #

  erb_template <<-ERB
    <div <%= html_attributes %>>
      <%= content %>
      <% @items.each_with_index do |item, index| %>
        <details class="accordion-item <%= item[:item_class] if item.key?(:item_class) %>">
          <summary
            id="<%= index %>_<%= item[:the_title] %>"
            role="<%= "button" if item.key?(:is_button) && item[:is_button] %>"
            class="<%= item[:title_class] if item.key?(:title_class) %>">
            <%= item[:the_title] %>
          </summary>
          <p class="<%= item[:content_class] if item.key?(:content_class) %>">
            <%= item[:the_content] %>
          </p>
        </details>
      <% end %>
    </div>
  ERB

  # Initializes the AccordionComponent with optional CSS class, HTML options, and items.
  #
  # @param css_class [String] The CSS class for the accordion container.
  # @param html_options [Hash] Additional HTML attributes for the accordion container.
  # @param items [Array<Hash>] An array of items, each containing at least a title and content.

  def initialize(css_class: "accordian-container", html_options: {}, items: [])
    super(css_class: css_class, html_options: html_options)
    @items = items
  end

  def html_attributes
    super
  end
end
