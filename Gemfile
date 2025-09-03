source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.6"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # Adding Spring et. al. to try resolve why activestorage
  # and actiontext are not being loaded in development
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  # Custom Additions
  gem "faker", :git => "https://github.com/faker-ruby/faker.git", :branch => "main"
  # Testing gems for TDD with RSpec
  gem "pry-rails" # For debugging in the Rails console
  gem "pry-byebug" # For debugging with Byebug in Pry
  gem "rails-controller-testing" # For testing Rails controllers
  gem "rspec-rails"
  gem "factory_bot_rails" # For test data generation
  gem "shoulda-matchers" # For common Rails model tests
  gem "capybara" # For integration/feature tests
  gem "capybara-webkit" # For JavaScript support in Capybara tests
  gem "webrick" # For running a web server in tests (needed for Rails 7+)
  gem "capybara-screenshot" # For taking screenshots on test failures
  gem "selenium-webdriver" # Required by Capybara for browser testing
  gem "database_cleaner-active_record" # For cleaning the database between tests
  gem "simplecov", require: false # For test coverage reports
  gem "rubocop", require: false # For code style checking
  gem "rubocop-rspec", require: false # RSpec specific RuboCop rules
  # gem "rspec_junit_formatter" # For generating JUnit XML reports from RSpec tests
  gem "annotate", git: "https://github.com/ctran/annotate_models.git"
  gem "parallel_tests"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

# group :test do
## Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
# gem "capybara"
# gem "selenium-webdriver"
# end

# Custom addition
gem "dotenv-rails"
gem "devise"
gem "pundit"
gem "autoprefixer-rails"
gem "font-awesome-sass"
gem "simple_form", github: "heartcombo/simple_form"
gem "view_component"
# gem "vanilla_nested", github: "arielj/vanilla-nested", branch: :main
gem "image_processing", "~> 1.14"
gem "cssbundling-rails"
