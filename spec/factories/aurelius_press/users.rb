# == Schema Information
#
# Table name: aurelius_press_users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  age                    :integer
#  role                   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  status                 :integer          default("active"), not null
#
# spec/factories/users.rb
FactoryBot.define do
  factory :aurelius_press_user, class: "AureliusPress::User" do
    # Generates a unique email address for each user factory
    sequence(:email) { |n| "user#{n}@example.com" }
    # Sets a default password for the user
    password { "password123" }
    # Confirms the password, required by Devise's :validatable module
    password_confirmation { password }
    # Generates a realistic first name
    first_name { Faker::Name.first_name }
    # Generates a realistic last name
    last_name { Faker::Name.last_name }
    # Combines first and last name to create a username
    username { Faker::Internet.unique.username(specifier: "#{first_name} #{last_name}") }
    # Sets the default role for the user
    role { :reader } # e.g., :reader, :contributor, :editor, :moderator, :admin, :superuser
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
      # Provides a short biography for the user
      user.bio { ActionText::RichText.new(body: "This is #{user.first_name}'s bio.") }
    end

    trait :with_group do
      association :group, factory: :aurelius_press_group
    end

    factory :aurelius_press_contributor_user, parent: :aurelius_press_user do
      role { :contributor }
    end

    factory :aurelius_press_editor_user, parent: :aurelius_press_user do
      role { :editor }
    end

    factory :aurelius_press_moderator_user, parent: :aurelius_press_user do
      role { :moderator }
    end

    factory :aurelius_press_admin_user, parent: :aurelius_press_user do
      role { :admin }
    end

    factory :aurelius_press_superuser_user, parent: :aurelius_press_user do
      role { :superuser }
    end
  end
end
