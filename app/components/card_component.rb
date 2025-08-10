# frozen_string_literal: true

class CardComponent < ApplicationComponent
  erb_template <<-ERB
    <article <%= html_attributes %>>
      <% if @title or @subtitle %>
      <header class="header">
        <hgroup>
          <% if @title %>
            <h3 class="title">
              <%= @title %>
            </h3>
          <% end %>
          <% if @subtitle %>
          <p class="subtitle"><%= @subtitle %></p>
          <% end %>
        </hgroup>
      </header>
      <% end %>
      <section class="content">
        <%= content %>
      </section>
      <% if @ctas.length.positive? %>
      <footer class="footer">
        <% @ctas.each do |cta| %>
          <%= cta %>
        <% end %>
      </footer>
      <% end %>
    </article>
  ERB

  # CardComponent is a component for creating a card-style UI element.
  # It allows for a background image, title, subtitle, content, and multiple
  # call-to-action links.
  #
  # The component can be customized with CSS classes and HTML options.
  # e.g.
  #   <%= render CardComponent.new(
  #     src: "path/to/image.jpg",
  #     title: "Card Title",
  #     subtitle: "Card Subtitle",
  #     ctas: [
  #       { href: "/link1", text: "Link 1", class: "primary", role: "button" },
  #       { href: "/link2", text: "Link 2", class: "secondary", role: "link" }
  #     ],
  #     css_class: "custom-card",
  #     html_options: { data: { controller: "card" } }
  #   ) %>
  def initialize(
    src: "",
    title: nil,
    subtitle: nil,
    ctas: [],
    css_class: "",
    html_options: {}
  )
    inline_styles = {}
    # Add the background image as a style attribute
    if not src.nil? and src.length.positive?
      inline_styles = {
        background_image: "url('#{src}')",
        background_size: "cover",
        background_position: "center",
      }
    end

    super(
      css_class: "card #{css_class}",
      html_options: merge_hashes(html_options, { style: inline_styles }),
    )

    @title = title
    @subtitle = subtitle
    @src = src
    @ctas = ctas.map do |cta|
      # Ensure keys are symbols
      cta = cta.deep_symbolize_keys
      # Ensure each CTA has a default role and class
      cta[:role] ||= "link"
      cta[:class] ||= "primary"
      # Modify the class list and build the attributes hash
      attributes = {
        class: "cta-link #{cta[:class]}",
        href: cta[:href],
        role: cta[:role],
      }
      # Generate and return the HTML for the link
      tag.a cta[:text] || "Click here", **attributes
    end
  end

  def html_attributes
    super
  end

  def merge_hashes(retHash, *args)
    super(retHash, *args)
  end
end
