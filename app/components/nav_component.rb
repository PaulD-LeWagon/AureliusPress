# frozen_string_literal: true

class NavComponent < ApplicationComponent
  # This component is used to render a navigation bar with dropdown menus.
  # It can be customized with CSS classes and HTML options.
  # The default title is "Simple CMS", and it includes a placeholder for admin pages.

  # include DropdownComponent

  attr_reader :title, :nav_items, :css_class, :html_options

  erb_template <<-ERB

  <nav <%= html_attributes %>>
    <ul>
      <li><strong><%= @title %></strong></li>
    </ul>
    <ul>
      <% if @page_items&.any? %>
      <li>
        <details class="dropdown">
          <summary><span class="icon">☰</span></summary>
          <ul dir="rtl">
            <% @page_items.each do |item| %>
            <li><a href="<%= item[:href] %>"><%= item[:text] %></a></li>
            <% end %>
          </ul>
        </details>
      </li>
      <% else %>
      <li>Nothing to show, yet!</li>
      <% end %>
      <% if @admin_items&.any? %>
      <li>
        <details class="dropdown">
          <summary>
            <span class="icon">⚙️</span> Admin
          </summary>
          <ul dir="rtl">
            <% @admin_items.each do |item| %>
            <li><a href="<%= item[:href] %>"><%= item[:text] %></a></li>
            <% end %>
          </ul>
        </details>
      </li>
      <% end %>
    </ul>
  </nav>

  ERB

  def initialize(css_class: "", html_options: {}, title: "Simple CMS", nav_items: {})
    super(css_class: css_class, html_options: html_options)
    @css_class = css_class
    @admin_items = nav_items[:admin] if nav_items&.key?(:admin)
    @page_items = nav_items[:pages] if nav_items&.key?(:pages)
    @title = title
  end

  def html_attributes
    super
  end

  def merge_hashes(retHash, *args)
    super(retHash, *args)
  end
end
