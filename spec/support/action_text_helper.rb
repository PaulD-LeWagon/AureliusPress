module ActionTextHelper
  # Finds a Trix rich-text editor by the text of its associated <label>, then
  # sets its content. ActionText renders <trix-editor id="field_id" input="...hidden_id...">
  # where the trix-editor's `id` matches the label's `for` attribute (not its `input` attr).
  # Uses the Trix JS API directly to avoid Cuprite's mouse-event overlap checks.
  def fill_in_rich_text_area(locator, with:)
    label     = find("label", text: locator)
    editor_id = label[:for]
    find("trix-editor##{editor_id}")
    page.execute_script(<<~JS, with)
      const editor = document.querySelector('trix-editor##{editor_id}');
      editor.focus();
      const len = editor.editor.getDocument().getLength();
      if (len > 0) editor.editor.setSelectedRange([0, len]);
      editor.editor.insertString(arguments[0]);
    JS
  end
end
