# AureliusPress

A minimalist, Stoic-inspired content management system and digital publishing platform built with Ruby on Rails 7.2.

---

## Overview

AureliusPress is a full-featured CMS for publishing written content — blog posts, journal entries, and a quote catalogue — with a community engagement layer (likes, reactions, comments, notes, groups).

The platform is designed around a single author/publisher workflow with admin-managed content, a public-facing reader interface, and a private journaling feature.

---

## Stack

| Layer | Technology |
|---|---|
| Framework | Ruby on Rails 7.2 |
| Ruby | 3.3.x |
| Database | PostgreSQL |
| Frontend | Hotwire (Turbo + Stimulus), PicoCSS + Tyrian Purple theme |
| Auth | Devise |
| Authorization | Pundit |
| Testing | RSpec, FactoryBot, Capybara (Firefox headless), DatabaseCleaner |
| Background jobs | SolidQueue (PostgreSQL-backed) |
| Image processing | libvips + ActiveStorage |
| Deployment | Alma Linux VPS, Apache + Phusion Passenger |

---

## Features

- **Documents** — Blog posts, atomic blog posts, pages, and private journal entries (full CRUD + content blocks)
- **Catalogue** — Quotes, authors, and sources with taxonomy (tags, categories)
- **Community** — Likes, emoji reactions, comments, notes, group memberships
- **Admin panel** — Content moderation (soft deletion), user management, site settings, pagination
- **API v1** — JSON endpoints for quotes and taxonomy
- **Authorization** — Role ladder: Guest → Reader → User → Moderator → Admin → Superuser

---

## Getting Started

```bash
# Install dependencies
bundle install
yarn install

# Database setup
bin/rails db:create db:migrate db:seed

# Start the server
bin/rails server
```

The app is mounted under the `/aurelius-press` namespace. Visit `http://localhost:3000/aurelius-press`.

---

## Testing

```bash
# Full test suite
bundle exec rspec

# With coverage report
COVERAGE=true bundle exec rspec

# Fast (no browser)
bundle exec rspec spec/models spec/policies spec/requests --format progress

# Feature specs only (browser required)
bundle exec rspec spec/features --format progress
```

Coverage is enforced at **70% minimum** in CI (via SimpleCov).

---

## Architecture

```
app/
  controllers/aurelius_press/
    admin/          # Admin namespace (moderation, settings, user management)
    api/v1/         # JSON API
    community/      # Likes, reactions, groups, memberships
    catalogue/      # Quotes, authors, sources
    document/       # Blog posts, journal entries, pages
  models/aurelius_press/
  policies/aurelius_press/   # Pundit policies (role-based)
  views/aurelius_press/
design/                      # Sprint plans, backlog, ADRs, testing strategy
```

All models, controllers, policies, and views live under the `AureliusPress::` module namespace.

---

## Deployment

```bash
git pull origin master
bundle install
bin/rails db:migrate
bin/rails assets:precompile
passenger-config restart-app .
```

---

## License

Private — all rights reserved.
