# System Design - AureliusPress (Stage 1)

## Architecture Overview
The system follows a standard Ruby on Rails MVC (Model-View-Controller) pattern, namespaced broadly under `AureliusPress` for isolated domain logic. 

## Technical Manifest
- **Stack**: 
  - Ruby: RSpec for Testing.
  - Framework: Ruby on Rails v7.2+
  - Frontend: PicoCSS (Vanilla HTML) - Stimulus/Hotwire planned for Stage 2.
- **Environment**: 
  - Alma VPS targeting Apache + Phusion Passenger.

## Interfaces & Modules
- **Entities**: 
  - `AureliusPress::Document::BlogPost`
  - `AureliusPress::Document::AtomicBlogPost`
  - `AureliusPress::Document::ContentBlock`
  - `AureliusPress::User` (Devise, Admin roles)
- **Controllers**: MVC namespace routing divided into `admin/document/` and public-facing routes.
  - **Routing Architecture Design Rule**: The overall application delegates purely internal objects (e.g. Roles, Users, Permissions, Reactions, Likes, Groups, Comments, Notes) to standard Rails `:id` lookups. However, models designated for public SEO via `Sluggable` (e.g. Documents, Authors, Categories) overwrite their `to_param` to `self.slug`. This native overwrite impacts all Rails path helpers, meaning the Admin interfaces must use `.find_by!(slug: params[:id])` for these specific Sluggable models. This prevents manually overwriting `(id: @object.id)` across the entire Admin codebase, maintaining DRY principles.

## Storage
- **File System**: ActiveStorage with local disk for testing, system `libvips` for image mutations.
- **RDBMS**: PostgreSQL

## Observability & State
- SolidQueue integrated directly into PostgreSQL to eliminate the need for an external Redis key-value store instance for background jobs.
- SolidCable for WebSockets.
