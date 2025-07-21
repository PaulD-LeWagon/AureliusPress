# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    # Generates a unique email address for each user factory
    email { Faker::Internet.unique.email }
    # Sets a default password for the user
    password { "password123" }
    # Confirms the password, required by Devise's :validatable module
    password_confirmation { "password123" }

    first_name { Faker::Name.first_name } # Generates a realistic first name
    last_name { Faker::Name.last_name } # Generates a realistic last name
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
        user.avatar.attach(io: File.open(Rails.root.join("spec", "fixtures", "files", "test_avatar.png")), filename: "test_avatar.png", content_type: "image/png")
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
  end
end
