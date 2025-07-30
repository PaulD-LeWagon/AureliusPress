# spec/factories/users.rb
FactoryBot.define do
  factory :aurelius_press_user, class: "AureliusPress::User" do
    # Generates a unique email address for each user factory
    sequence(:email) { |n| "user#{n}@example.com" }
    # Sets a default password for the user
    password { "password123" }
    # Confirms the password, required by Devise's :validatable module
    password_confirmation { "password123" }
    # Generates a realistic first name
    first_name { Faker::Name.first_name }
    # Generates a realistic last name
    last_name { Faker::Name.last_name }
    # Combines first and last name to create a username
    username { Faker::Internet.unique.username(specifier: "#{first_name} #{last_name}") }
    # Sets the default role for the user
    # role { :user } # e.g., :user, :moderator, :admin, :superuser
    # Provides a short biography for the user
    bio { Faker::Lorem.paragraph(sentence_count: 2) }
    # Attaches an avatar image using Active Storage.
    # This assumes you have a 'test_image.png' file in your spec/fixtures/files directory.
    # Make sure to create this directory and place a dummy image file there.
    after(:build) do |user|
      unless user.avatar.attached?
        # Use a fixture file for attaching. Ensure you have one at the specified path.
        # This requires `include ActionDispatch::TestProcess::FixtureFile` in your spec_helper or rails_helper
        # or just use Rack::Test::UploadedFile.new directly.
        user.avatar.attach(
          io: File.open(Rails.root.join(
            "spec",
            "fixtures",
            "files",
            "test_avatar.png"
          )),
          filename: "test_avatar.png",
          content_type: "image/png",
        )
      end
    end
    # Traits for different user roles
    # user contributor moderator admin superuser
    trait :contributor do
      role { :contributor }
    end

    trait :moderator do
      role { :moderator }
    end

    trait :admin do
      role { :admin }
    end

    trait :superuser do
      role { :superuser }
    end

    trait :with_group do
      association :group, factory: :aurelius_press_group
    end
  end
end
