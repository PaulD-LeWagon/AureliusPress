module DebugHelper
  def print_debug_info
    # Check for the presence of validation errors
    if page.has_css?(".error-messages")
      puts "Test failed due to validation errors. See page body below:"
      puts page.body
    end
  end
end
