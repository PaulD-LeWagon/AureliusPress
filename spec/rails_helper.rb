# This file is copied to spec/ when you run 'rails generate rspec:install'
require "launchy"
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!

require "action_text/system_test_helper"

# For Active Storage fixture file uploads
require "action_dispatch/testing/test_process"

require "database_cleaner/active_record"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

# Ensures that the test database schema matches the current schema file.
# If there are pending migrations it will invoke `db:test:prepare` to
# recreate the test database by loading the schema.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

module FactoryBot
  module Syntax
    module Methods
      alias_method :original_create_list, :create_list

      def create_list(name, amount, *traits_and_overrides, &block)
        if amount > 3
          raise ArgumentError, "You asked to create #{amount} records. Too many - Don't do that!"
        end

        original_create_list(name, amount, *traits_and_overrides, &block)
      end
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a testing framework:
    with.test_framework :rspec
    ## Choose one or more libraries:
    # with.library :active_record
    # with.library :active_model
    # with.library :action_controller # Only if you're testing controllers
    # Or, to just integrate everything:
    with.library :rails
  end
end

RSpec.configure do |config|
  # To run specific tests, you can use the `:focus` metadata tag.
  # This will run only the tests that have this tag.
  # For example, you can run `rspec --tag focus` to run only focused tests.
  config.filter_run_when_matching :focus
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join("spec/fixtures"),
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation) # Cleans entire DB before the suite runs
  end

  config.around(:each) do |example|
    # If the example has :truncation or :js metadata, use truncation strategy.
    # Otherwise, use transaction strategy (default for most tests).
    DatabaseCleaner.strategy = example.metadata[:truncation] || example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.cleaning do
      example.run # Runs the test example within DatabaseCleaner's context
    end
  end

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails uses metadata to mix in different behaviours to your tests,
  # for example enabling you to call `get` and `post` in request specs. e.g.:
  #
  #     RSpec.describe UsersController, type: :request do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/8-0/rspec-rails
  #
  # You can also this infer these behaviours automatically by location, e.g.
  # /spec/models would pull in the same behaviour as `type: :model` but this
  # behaviour is considered legacy and will be removed in a future version.
  #
  # To enable this behaviour uncomment the line below.
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Include for fixture_file_upload helper
  config.include ActionDispatch::TestProcess::FixtureFile

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Ensure Active Storage attachments are cleaned up after each test
  config.after do
    ActiveStorage::Blob.unattached.find_each(&:purge)
  end
end
