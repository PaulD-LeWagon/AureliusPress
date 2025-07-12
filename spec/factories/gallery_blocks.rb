# spec/factories/gallery_blocks.rb
FactoryBot.define do
  factory :gallery_block do
    association :content_block
    layout_type { GalleryBlock.layout_types.keys.sample }

    # Attach multiple images to the gallery
    after(:build) do |block|
      unless block.images.attached?
        # Attach 2-3 images
        3.times do |i|
          block.images.attach(io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image_#{i + 1}.png")), filename: "gallery_image_#{i + 1}.png", content_type: "image/png")
        end
      end
    end
  end
end
