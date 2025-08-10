module ActionTextHelper
  def fill_in_rich_text_area(locator, with:)
    input_id = ""
    find("trix-editor[id='#{locator}']").tap do |editor|
      editor.click
      editor.set(with)
      input_id = editor[:input]
    end
    execute_script("document.getElementById(arguments[0]).value = arguments[1]", input_id, with)
  end
end
