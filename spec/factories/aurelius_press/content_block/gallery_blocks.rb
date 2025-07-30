# spec/factories/gallery_blocks.rb
FactoryBot.define do
  factory :aurelius_press_content_block_gallery_block, class: "AureliusPress::ContentBlock::GalleryBlock" do
    layout_type { :carousel }

    # Attach multiple images to the gallery
    after(:build) do |block|
      unless block.images.attached?
        # Attach 3 images
        3.times do |i|
          block.images.attach(
            io: File.open(Rails.root.join(
              "spec",
              "fixtures",
              "files",
              "test_image.png"
            )),
            filename: "gallery_image_#{i + 1}.png",
            content_type: "image/png",
          )
        end
      end
    end

    trait :with_out_images do
      after(:build) do |block|
        block.images.purge # Ensure no images are attached
      end
    end
  end
end
