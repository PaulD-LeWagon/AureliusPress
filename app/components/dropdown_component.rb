# frozen_string_literal: true

class DropdownComponent < ApplicationComponent
  erb_template <<-ERB

    <details <%= html_attributes %>>
      <summary><%= @title %></summary>
      <ul>
        <% @items.each do |item| %>
          <%= item %>
        <% end %>
      </ul>
    </details>

  ERB

  def initialize(css_class: "", html_options: {}, items: [], title: "Dropdown Menu")
    super(css_class: "dropdown #{css_class}", html_options: html_options)

    @title = title

    @items = items.map do |link|
      # Ensure keys are symbols
      link = link.deep_symbolize_keys
      # Ensure each link has a default role and class
      link[:role] ||= "link"
      link[:class] ||= "primary"
      # Create the anchor tag's attributes
      attributes = {
        class: "dropdown-link #{link[:class]}",
        href: link[:href],
        role: link[:role],
      }
      # Generate the HTML for the list item
      tag.li do
        tag.a link[:text] || "Click here", **attributes
      end
    end
  end

  def html_attributes
    super
  end

  def merge_hashes(retHash, *args)
    super(retHash, *args)
  end
end
