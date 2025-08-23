module DataAttributesHelper
  # # Converts a custom string to a nested hash.
  # # "data-cb-value=\"one\"" -> { data: { cb: { value: "one" } } }
  # def string_to_data_hash(str)
  #   # Use a regex to capture the key and value
  #   match = str.match(/data-([a-zA-Z-]+)="(.*)"/)
  #   return {} unless match
  #   # Split the key by hyphens and build the nested hash
  #   keys = match[1].split("-").map(&:to_sym)
  #   value = match[2]
  #   # Dynamically build the nested hash
  #   hash = {}
  #   last_hash = hash
  #   keys.each_with_index do |key, index|
  #     if index == keys.length - 1
  #       last_hash[key] = value
  #     else
  #       last_hash[key] = {}
  #       last_hash = last_hash[key]
  #     end
  #   end
  #   { data: hash }
  # end
  # Converts a custom string with multiple data-attributes to a nested hash.
  # "data-one-two=\"3\" data-three-four=\"5\"" -> { "data" => { "one" => { "two" => "3" }, "three" => { "four" => "5" } } }
  def string_to_data_hash(str)
    return {} unless str.is_a?(String)
    final_hash = { "data" => {} }
    # Regex to find all data- attributes
    str.scan(/data-([a-zA-Z-]+)="(.*?)"/) do |match|
      keys = match[0].split("-")
      value = match[1]
      # Build the nested hash for the current attribute
      current_hash = final_hash["data"]
      keys.each_with_index do |key, index|
        if index == keys.length - 1
          current_hash[key] = value
        else
          current_hash[key] ||= {}
          current_hash = current_hash[key]
        end
      end
    end
    final_hash
  end

  # Converts a nested hash back to a custom string.
  # { data: { cb: { value: "one" } } } -> "data-cb-value=\"one\""
  def data_hash_to_string(hash)
    return "" unless hash.is_a?(Hash) && hash.key?("data")
    # This method recursively builds the data attribute string
    def build_data_string(current_hash, prefix)
      current_hash.map do |key, value|
        if value.is_a?(Hash)
          build_data_string(value, "#{prefix}-#{key}")
        else
          "#{prefix}-#{key}=\"#{value}\""
        end
      end.join(" ")
    end
    build_data_string(hash["data"], "data")
  end

  # def parse_data_attributes(value)
  #   # Handle the hash format
  #   if value.is_a?(Hash)
  #     return value
  #   end
  #   # Handle the JSON string format (e.g., '{ "data": { "cb": { "test": "one" } } }')
  #   begin
  #     parsed_json = JSON.parse(value)
  #     return parsed_json if parsed_json.is_a?(Hash)
  #   rescue JSON::ParserError
  #     # Move on if it's not a valid JSON string
  #   end
  #   # Handle the custom string format (e.g., 'data-cb-test-value="one"')
  #   match = value.match(/data-([a-zA-Z-]+)="(.*)"/)
  #   if match
  #     keys = match[1].split("-").map(&:to_sym)
  #     parsed_value = match[2]
  #     # Build the nested hash dynamically
  #     hash = {}
  #     last_hash = hash
  #     keys.each_with_index do |key, index|
  #       if index == keys.length - 1
  #         last_hash[key] = parsed_value
  #       else
  #         last_hash[key] = {}
  #         last_hash = last_hash[key]
  #       end
  #     end
  #     return hash
  #   end
  #   # Return an empty hash if no format matches
  #   {}
  # end

  # def parse_hash_string(str)
  #   # The string must start with 'data:' and be valid
  #   return {} unless str.is_a?(String) && str.strip.start_with?("data:")
  #   # Remove the 'data: ' prefix and outer curly braces
  #   content = str.strip.sub(/^data: \{/, "").sub(/\}$/, "").strip
  #   # Use a safe and powerful parser. This is a common and safer alternative to 'eval'
  #   # It dynamically parses keys and values without a hard-coded regex.
  #   parsed_hash = {}
  #   tokens = content.scan(/(\w+): \{([^}]*)\}|(\w+): "([^"]*)"|(\w+): (\d+)/)
  #   tokens.each do |key_block, nested_content, key_string, value_string, key_number, value_number|
  #     if key_block
  #       # Handle nested hash
  #       parsed_hash[key_block.to_sym] = parse_hash_string("data: { #{nested_content} }")
  #     elsif key_string
  #       # Handle string value
  #       parsed_hash[key_string.to_sym] = value_string
  #     elsif key_number
  #       # Handle number value
  #       parsed_hash[key_number.to_sym] = value_number.to_i
  #     end
  #   end
  #   parsed_hash
  # end
end
