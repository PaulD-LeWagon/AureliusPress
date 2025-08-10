# Requires the CGI library for HTML escaping to ensure attribute values are safe.
require "cgi"
# frozen_string_literal: true
class ApplicationComponent < ViewComponent::Base
  # Include Rails' built-in URL helpers
  include Rails.application.routes.url_helpers
  # Include Rails' built-in form helpers
  include Rails.application.helpers

  # Include other custom helper modules
  include ApplicationHelper

  # Define common attributes and / or methods for all sub-components.
  # This can include things like default HTML options, CSS classes, or shared methods.

  # Use `deep_symbolize_keys`
  attr_reader :html_options

  # Initialize with common HTML options.
  def initialize(css_class: "hd-app-comp", html_options: {})
    @html_options = html_options
      .deep_merge!(class: merge_classes(css_class, html_options[:class]))
      .deep_symbolize_keys
    super()
  end

  def merge_classes(*args)
    args.flatten.compact.join(" ").strip
  end

  def merge_hashes(retHash, *args)
    args.each do |arg|
      if arg.is_a?(Hash)
        retHash = retHash.deep_merge(arg)
      else
        raise ArgumentError, "Expected a Hash, got #{arg.class}"
      end
    end
    retHash
  end

  # Merge and build CSS classes.
  # CANNOT BE USED IN INITIALIZER, AS IT IS ONLY ONCE YOU HAVE A VIEW CONTEXT.
  def class_names(*args)
    # ViewComponent's `class_names` helper, convenient for building class strings.
    # e.g., class_names("btn", { "btn--primary" => primary, "btn--disabled" => disabled })
    helpers.class_names(*args)
  end

  # # Define a default `content_tag` method if you often wrap content
  # # in a specific kind of tag with common attributes.
  # # def default_wrapper(&block)
  # #   content_tag(:div, class: "component-wrapper", &block)
  # # end

  # Converts a Hash into a string of HTML attributes.
  #
  # This method handles several specific cases:
  # - Regular key-value pairs are converted to "key='value'", with underscores
  #   in the key replaced by hyphens.
  # - Boolean `true` values result in a standalone attribute (e.g., 'disabled').
  # - `nil` or `false` values are skipped (attribute omitted).
  # - A top-level 'data' key will trigger special handling for custom data attributes:
  #   - Nested hashes under 'data' are recursively flattened into 'data-key-subkey="value"'
  #     format.
  #   - **Both camelCase and snake_case key segments are converted to kebab-case.**
  # - A top-level 'style' key will generate an inline CSS style string:
  #   - Nested hashes under 'style' are recursively flattened into 'property-subproperty: value;'
  #     format.
  #   - **Both camelCase and snake_case key segments are converted to kebab-case.**
  # - All attribute values are HTML-escaped to prevent injection issues.
  #
  # @param attributes_hash [Hash] The input hash of attributes.
  # @return [String] A space-separated string of HTML attributes.
  def html_attributes(attributes_hash = @html_options || {})
    html_attributes_array = []

    attributes_hash.each do |key, value|
      case key.to_s
      when "data"
        # Process data-* attributes, which may be nested and require consistent key transformation
        html_attributes_array.concat(process_data_attributes(value))
      when "style"
        # Process the style attribute for inline CSS
        html_attributes_array << process_style_attribute(value)
      else
        # Handle general HTML attributes
        # Convert underscores in general attribute keys to hyphens
        formatted_key = key.to_s.gsub("_", "-")

        if value.is_a?(TrueClass)
          # For boolean attributes (e.g., <input type="checkbox" checked>)
          html_attributes_array << formatted_key
        elsif value.is_a?(FalseClass) || value.nil?
          # If value is false or nil, the attribute is omitted
          next
        elsif value.is_a?(Hash) || value.is_a?(Array)
          # For other nested structures not under 'data' or 'style',
          # convert them to JSON strings and escape for the attribute value.
          escaped_value = CGI.escapeHTML(value.to_json)
          html_attributes_array << "#{formatted_key}=\"#{escaped_value}\""
        else
          # For simple string or numeric values, just escape and format
          escaped_value = CGI.escapeHTML(value.to_s)
          html_attributes_array << "#{formatted_key}=\"#{escaped_value}\""
        end
      end
    end

    # Join all processed attributes with a space
    raw html_attributes_array.join(" ")
  end

  private

  # Helper method to convert camelCase or snake_case strings to kebab-case.
  #
  # @param is [String, Symbol] The string to convert.
  # @return [String] The converted kebab-case string.
  def to_kebab_case(is)
    is.to_s
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1-\2') # Handles ABc to A-Bc
      .gsub(/([a-z\d])([A-Z])/, '\1-\2') # Handles aB to a-B
      .gsub("_", "-") # Handles snake_case to kebab-case
      .downcase # Ensure all lowercase
  end

  # Recursively processes a hash to generate data-* attributes.
  # Keys are joined with hyphens and converted from camelCase/snake_case to kebab-case.
  #
  # @param data_hash [Hash] The hash representing the data attribute structure.
  # @param current_key_parts [Array<String>] Internal array to build the attribute key path.
  # @param result [Array<String>] Internal array to collect the generated attribute strings.
  # @return [Array<String>] An array of formatted data attribute strings (e.g., "data-user-id=\"123\"").
  def process_data_attributes(data_hash, current_key_parts = [], result = [])
    data_hash.each do |key, value|
      # Convert each segment of the key to kebab-case (handling both camelCase and snake_case)
      formatted_key_segment = to_kebab_case(key)

      # Append the current segment to the key path
      new_key_parts = current_key_parts + [formatted_key_segment]

      if value.is_a?(Hash)
        # If the value is another hash, recurse to process nested data
        process_data_attributes(value, new_key_parts, result)
      elsif value.is_a?(Array)
        # Arrays are converted to JSON strings for data attribute values
        full_data_key = "data-#{new_key_parts.join("-")}"
        escaped_value = CGI.escapeHTML(value.to_json)
        result << "#{full_data_key}=\"#{escaped_value}\""
      else
        # For simple values (string, number, boolean), form the final attribute
        full_data_key = "data-#{new_key_parts.join("-")}"
        escaped_value = CGI.escapeHTML(value.to_s)
        result << "#{full_data_key}=\"#{escaped_value}\""
      end
    end
    result
  end

  # Processes a hash to generate the inline 'style' attribute string.
  # Keys are converted from camelCase/snake_case to kebab-case for CSS properties,
  # and nested hashes are joined with hyphens to form combined property names.
  #
  # @param style_hash [Hash] The hash representing the CSS style properties.
  # @param current_property_parts [Array<String>] Internal array to build the CSS property name path.
  # @param result_properties [Array<String>] Internal array to collect the generated CSS property strings.
  # @return [String] The formatted 'style' attribute string (e.g., "style=\"font-size: 16px;\"").
  def process_style_attribute(style_hash, current_property_parts = [], result_properties = [])
    style_hash.each do |key, value|
      # Convert each segment of the CSS property name to kebab-case (handling both camelCase and snake_case)
      css_property_segment = to_kebab_case(key)

      # Append the current segment to the property name path
      new_property_parts = current_property_parts + [css_property_segment]

      if value.is_a?(Hash)
        # If the value is another hash, recurse to process nested style properties
        # (e.g., { margin: { top: '10px' } } becomes 'margin-top')
        process_style_attribute(value, new_property_parts, result_properties)
      else
        # For simple values, form the final CSS property string (e.g., "font-size: 16px")
        full_css_property = new_property_parts.join("-")
        result_properties << "#{full_css_property}: #{value}"
      end
    end
    # Join all CSS properties with a semicolon and space, then wrap in 'style="..."'
    "style=\"#{result_properties.join("; ")}\""
  end
end
