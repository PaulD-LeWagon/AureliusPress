module ActionTextHelper
  # def fill_in_rich_text_area(locator, with:)
  #   find("trix-editor[input='aurelius_press_user_bio_trix_input_aurelius_press_user']", visible: true).click.set(with)
  # end

  def fill_in_rich_text_area(locator, with:)
    find("trix-editor", visible: true).click.set(with)
  end

  Capybara.add_selector(:rich_text_area) do
    label "rich text area"
    visible :all
    xpath do |locator|
      if locator.nil?
        XPath.css("trix-editor")
      else
        XPath.css("label[for='#{locator}'] + trix-editor").attr(:id)
      end
    end
  end
end
