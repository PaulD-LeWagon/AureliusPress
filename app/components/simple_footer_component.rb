# frozen_string_literal: true

class SimpleFooterComponent < ApplicationComponent
  # This component is used to render a simple footer with a container class.
  # It can be customized with CSS classes and HTML options.

  attr_reader :css_class, :html_options

  erb_template <<-ERB
    <footer <%= html_attributes %>>

      <%= content %>

      <p><em>La Rógue Digitál</em> © 2024-<%= Time.current.year %></p>

    </footer>
  ERB

  def initialize(css_class: "container", html_options: {})
    super(css_class: css_class, html_options: html_options)
  end

  def html_attributes
    super
  end

  def merge_hashes(retHash, *args)
    super(retHash, *args)
  end
end
