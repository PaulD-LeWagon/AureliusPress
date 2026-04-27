# ADR: Admin Settings Store

**Date:** 2026-04-27  
**Status:** Accepted  
**Sprint:** 4 (S4-06)

---

## Context

Sprint 4 requires a configurable site settings panel scoped to ≤5 runtime keys. Two options were evaluated:

1. `rails-settings-cached` gem (2.9.6) — caching key-value store backed by a DB table
2. Custom `aurelius_press_site_settings` table — bespoke key-value model

## Decision

**Custom table** (`AureliusPress::SiteSetting` model, `aurelius_press_site_settings` table).

## Rationale

- Adding a gem for 5 settings is disproportionate; the custom table is ~40 lines of code.
- Full transparency: the schema, validations, and casting logic are in-repo and not a black box.
- No risk of gem version incompatibility with Rails 7.2.
- The sprint plan explicitly listed "custom key-value table" as the preferred fallback — used here as the primary choice.

## Settings in Scope (Sprint 4)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `site_name` | string | "AureliusPress" | Display name in nav/header |
| `site_description` | string | "" | Meta description / tagline |
| `registration_open` | boolean | true | Allow new user sign-ups |
| `default_visibility` | string | "private_to_owner" | Default doc visibility for new documents |
| `comments_enabled` | boolean | true | Global kill-switch for comments |

## Schema

```ruby
create_table "aurelius_press_site_settings" do |t|
  t.string "key",        null: false
  t.string "value"
  t.string "value_type", null: false, default: "string"
  t.string "description"
  t.timestamps
  t.index ["key"], unique: true
end
```

## Consequences

- Admin UI reads/writes via `AureliusPress::SiteSetting.get(key)` / `AureliusPress::SiteSetting.set(key, value)`.
- Seeded with the 5 defaults on `db:seed`.
- No caching in Sprint 4 — queried per request. Cache layer is Sprint 5 scope if needed.
