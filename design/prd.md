# Product Requirements Document (PRD) - AureliusPress (Stage 1)

## Executive Summary
AureliusPress is a minimalist, Stoic-inspired content management system (CMS) and digital publishing platform. For Stage 1 (MVP), the explicit goal is to bring the core CMS capabilities online so the author can publish their very first post on a live Alma VPS environment.

## Functional Requirements
- **Admin Authentication**: The system must allow an administrator to log in securely.
- **Content Creation**: The administrator must be able to create, edit, update, and delete Blog Posts.
- **Content Blocks**: The administrator must be able to attach text fields (and eventually modular content blocks) to a Blog Post to structure content.
- **Taxonomies**: Posts must be assignable to Categories and Tags.
- **Public Viewing**: Readers must be able to visit the front-end homepage and read published Blog Posts.

## Technical Constraints & Environment
- **Server**: Alma VPS running Apache web server and Phusion Passenger.
- **Language/Framework**: Ruby on Rails 7.2+, Ruby 3.3+.
- **Database**: PostgreSQL (handling both data logic and ActionCable/SolidQueue background jobs).
- **CSS**: PicoCSS extended with a Tyrian Purple custom theme (Phase 2).
- **External Dependencies**: `libvips` required at the system level for ActiveStorage image processing.

## User Flow
1. **Admin logs in** via `/aurelius-press/users/sign_in`.
2. Admin navigates to the CMS dashboard.
3. Admin clicks "New Blog Post", inputs a title, content blocks, and publishes.
4. The system validates the input, saves to PostgreSQL, and makes the post public.
5. **Reader visits** `subdomain.devanney.uk` and reads the post on the homepage.

## Non-Functional Requirements
- **Performance**: The app must load efficiently via Apache/Passenger.
- **Aesthetic**: The application must reflect a "premium" design philosophy heavily inspired by Stoicism and Tyrian Purple contrast.
- **Agility**: Deployment must be simple via Git pull and manual `bundle install` initially.

## Success Metrics (Definition of Done)
1. RSpec Test Suite is completely green.
2. The author can successfully log in via a seeded admin account on the Alma VPS.
3. The author successfully publishes a test post on the live URL.
