# frozen_string_literal: true

class CardTileComponent < ApplicationComponent
  erb_template <<-ERB

    <article <%= html_attributes %>>
      <a href="<%= @cta_href %>" class="cta-link <%= @cta_class %>">
        <section class="content">
        <% if content.present? %>
          <%= content %>
        <% else %>
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
        <% end %>
        </section>
      </a>
    </article>

  ERB

  def initialize(
    title: nil,
    subtitle: nil,
    src: nil,
    cta_href: nil,
    cta_class: nil,
    css_class: "",
    html_options: {}
  )
    styles = {}
    # Add the background image as a style attribute
    if not src.nil? and src.length.positive?
      styles = {
        background_image: "url('#{src}')",
        background_size: "cover",
        background_position: "center",
      }
    end

    super(
      css_class: "tile card #{css_class}",
      html_options: merge_hashes(html_options, { style: styles }),
    )

    @title = title
    @subtitle = subtitle
    @cta_href = cta_href
    @cta_class = cta_class
  end

  def html_attributes
    super
  end

  def merge_hashes(retHash, *args)
    super(retHash, *args)
  end
end
