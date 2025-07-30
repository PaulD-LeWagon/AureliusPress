FactoryBot.define do
  factory :aurelius_press_document_blog_post, parent: :aurelius_press_document_document, class: "AureliusPress::Document::BlogPost" do
    type { "AureliusPress::Document::BlogPost" }
    comments_enabled { true }
    visibility { :public_to_www }
  end
end
