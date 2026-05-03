module ActionTextHelper
  # Finds a Trix rich-text editor by the text of its associated <label>, then
  # sets its content. ActionText renders <trix-editor id="field_id" input="...hidden_id...">
  # where the trix-editor's `id` matches the label's `for` attribute (not its `input` attr).
  def fill_in_rich_text_area(locator, with:)
    label     = find("label", text: locator)
    editor_id = label[:for]
    editor    = find("trix-editor##{editor_id}")
    editor.click
    editor.set(with)
  end
end
