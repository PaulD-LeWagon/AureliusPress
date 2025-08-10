# GEMINI.md

## Project Overview

This project is a Ruby on Rails application named "AureliusPress". Based on the file structure, dependencies, and database schema, it appears to be a content management system (CMS) or a digital publishing platform.

**Key Technologies:**

*   **Backend:** Ruby on Rails
*   **Database:** PostgreSQL
*   **Frontend:** Hotwire (Turbo & Stimulus), Sass for styling.
*   **Authentication:** Devise
*   **Authorization:** Pundit
*   **Testing:** RSpec

**Architecture:**

The application follows a standard Rails MVC architecture. The core functionality is organized within the `aurelius_press` namespace. The database schema includes tables for managing users, documents, authors, quotes, categories, tags, and other related content.

## Building and Running

**1. Setup:**

*   Install Ruby dependencies: `bundle install`
*   Install JavaScript dependencies: `yarn install`
*   Create the database: `rails db:create`
*   Run database migrations: `rails db:migrate`
*   Seed the database (if applicable): `rails db:seed`

**2. Running the application:**

The `Procfile.dev` file indicates that the following commands are used to run the application in a development environment:

*   **Web server:** `bin/rails server -p 3000`
*   **CSS watcher:** `yarn build:css --watch`

You can run these commands in separate terminals or use a tool like `foreman` to run them concurrently.

**3. Running tests:**

The project uses RSpec for testing. To run the test suite, use the following command:

`bundle exec rspec`

## Development Conventions

*   **Code Style:** The project uses RuboCop for maintaining a consistent code style.
*   **Testing:** Tests are written using RSpec. The `spec` directory contains tests for models, controllers, features, etc. FactoryBot is used for creating test data.
*   **Namespacing:** The core application logic is namespaced under `AureliusPress`. This helps to keep the code organized and avoid naming conflicts.
*   **Database Schema:** The database tables are prefixed with `aurelius_press_`, which is a good practice for namespacing tables in a larger application.
