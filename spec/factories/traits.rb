FactoryBot.define do
  # Trait for associating a concrete content block with a document via an
  # instance of a ContentBlock (Delegated Types)
  # Document > ContentBlock > (RichTextContentBlock, VideoEmbedBlock, etc.)
  trait :attached_to_a do
    transient do
      document_type { :blog_post }
      document_obj { nil }
    end
    after(:build) do |block, evaluator|
      block.content_block = build(
        :content_block,
        contentable: block,
        document: evaluator.document_obj || create(evaluator.document_type),
      )
    end
  end
end
