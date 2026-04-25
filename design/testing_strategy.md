# AureliusPress — Testing Strategy

> Generated: 2026-04-24  
> Stack: Rails 7.2 · RSpec · FactoryBot · Capybara (Firefox headless) · Pundit · DatabaseCleaner · Shoulda Matchers · Devise test helpers

---

## 1. Test Pyramid

```
         ┌─────────────────────────┐
         │     Feature / E2E       │  ~20%  Capybara + Selenium, :js, slow
         │  (Capybara + Selenium)  │        Golden path + access control
         ├─────────────────────────┤
         │    Request / Controller │  ~25%  HTTP layer, auth, redirects
         │       (RSpec request)   │        No JS, fast
         ├─────────────────────────┤
         │      Policy Specs       │  ~15%  Pundit rules, all roles
         │   (RSpec, type: :policy)│        Pure Ruby, very fast
         ├─────────────────────────┤
         │       Model / Unit      │  ~40%  Validations, associations, scopes
         │   (RSpec, type: :model) │        Pure Ruby, fastest
         └─────────────────────────┘
```

**Guiding principle:** Push logic as far down the pyramid as possible. A Pundit rule belongs in a policy spec, not a feature spec. A visibility scope belongs in a model spec, not a request spec. Feature specs exist only to prove the UI wires everything together.

---

## 2. Existing Test Infrastructure — Key Conventions

Before adding any tests, know what's already set up in `spec/rails_helper.rb`:

| Convention | Detail |
|---|---|
| **JS driver** | Firefox headless via `Capybara.register_driver :selenium_headless` |
| **JS metadata** | Tag examples with `:js` — this also switches DatabaseCleaner to `:truncation` |
| **Non-JS default** | DatabaseCleaner uses `:transaction` (rolls back after each example — fast) |
| **Auth helpers** | `sign_in` / `sign_out` via `Devise::Test::IntegrationHelpers` in feature/request specs |
| **FactoryBot guard** | `create_list` is capped at 3 records — never exceed this |
| **Role factories** | `create(:aurelius_press_user)`, `:aurelius_press_moderator_user`, `:aurelius_press_admin_user`, `:aurelius_press_superuser_user` |
| **Focus tag** | `:focus` metadata runs only those examples — remember to remove before committing |

---

## 3. Policy Testing (Phase 1 — Sprint 1 Priority)

### 3a. Setup

Create `spec/policies/` directory. Each policy file mirrors `app/policies/`:

```
spec/policies/
  aurelius_press/
    fragment/
      comment_policy_spec.rb
      note_policy_spec.rb
    community/
      like_policy_spec.rb
      group_policy_spec.rb
      group_membership_policy_spec.rb
    catalogue/
      author_policy_spec.rb
      source_policy_spec.rb
      quote_policy_spec.rb
    document/
      content_block_policy_spec.rb
    taxonomy/
      tag_policy_spec.rb
      category_policy_spec.rb
```

Add to `spec/rails_helper.rb` (if not already present):
```ruby
require "pundit/rspec"
```

### 3b. Policy Spec Template

Use this structure for every new policy. The `DocumentPolicy` is the gold standard — follow its role ladder.

```ruby
# spec/policies/aurelius_press/fragment/comment_policy_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Fragment::CommentPolicy, type: :policy do
  subject(:policy) { described_class.new(actor, comment) }

  # Shared setup — create the record owner separately so ownership tests
  # don't accidentally pass for the wrong reason.
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:reader)     { create(:aurelius_press_reader_user) }
  let(:moderator)  { create(:aurelius_press_moderator_user) }
  let(:admin)      { create(:aurelius_press_admin_user) }
  let(:superuser)  { create(:aurelius_press_superuser_user) }

  let(:commentable) { create(:aurelius_press_document_blog_post) }
  let(:comment)     { create(:aurelius_press_fragment_comment, user: owner, commentable: commentable) }

  # ── Guest (unauthenticated) ───────────────────────────────────────────────
  context "when actor is a guest (nil)" do
    let(:actor) { nil }
    it { is_expected.to forbid_action(:index)   }
    it { is_expected.to forbid_action(:show)    }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:destroy) }
  end

  # ── Reader ────────────────────────────────────────────────────────────────
  context "when actor is a reader" do
    let(:actor) { reader }
    it { is_expected.to permit_action(:index)   }
    it { is_expected.to permit_action(:show)    }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:destroy) }
  end

  # ── Regular user (not owner) ──────────────────────────────────────────────
  context "when actor is an authenticated user who does NOT own the comment" do
    let(:actor) { other_user }
    it { is_expected.to permit_action(:index)   }
    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:create)  }
    it { is_expected.to forbid_action(:destroy) }
  end

  # ── Owner ─────────────────────────────────────────────────────────────────
  context "when actor is the comment owner" do
    let(:actor) { owner }
    it { is_expected.to permit_action(:index)   }
    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:create)  }
    it { is_expected.to permit_action(:destroy) }
  end

  # ── Power users ───────────────────────────────────────────────────────────
  [
    [:moderator, :moderator],
    [:admin,     :admin],
    [:superuser, :superuser],
  ].each do |role, let_name|
    context "when actor is a #{role}" do
      let(:actor) { send(let_name) }
      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:destroy) }
    end
  end

  # ── Scope ─────────────────────────────────────────────────────────────────
  describe "Scope" do
    subject(:scope) { described_class::Scope.new(actor, AureliusPress::Fragment::Comment).resolve }

    let!(:public_comment)  { create(:aurelius_press_fragment_comment, commentable: commentable) }
    let!(:private_comment) { create(:aurelius_press_fragment_comment, commentable: create(:aurelius_press_document_blog_post, :private_to_owner)) }

    context "when actor is a guest" do
      let(:actor) { nil }
      # Adjust based on your business rule — guests may see comments on public docs only
      it "returns only comments on public documents" do
        expect(scope).to include(public_comment)
        expect(scope).not_to include(private_comment)
      end
    end

    context "when actor is a superuser" do
      let(:actor) { superuser }
      it "returns all comments" do
        expect(scope).to include(public_comment, private_comment)
      end
    end
  end
end
```

### 3c. Policy Rules Reference

Mirror the role ladder from `DocumentPolicy` — it's already the source of truth:

| Role | Can read others' | Can create | Can destroy own | Can destroy others' |
|---|---|---|---|---|
| Guest (nil) | public only | no | no | no |
| Reader | public + app | no | no | no |
| User | public + app + group | yes | yes | no |
| Moderator | all | yes | yes | yes |
| Admin | all | yes | yes | yes |
| Superuser | all | yes | yes | yes |

---

## 4. LikesController Testing

### 4a. What to Test

The `LikesController` is a JSON/Turbo API — it doesn't render HTML pages, so use **request specs** (not feature specs) for the HTTP layer.

```
spec/requests/
  aurelius_press/
    likes_spec.rb   ← already partially exists under admin; create public one
```

### 4b. Request Spec Template

```ruby
# spec/requests/aurelius_press/likes_spec.rb
require "rails_helper"

RSpec.describe "Likes", type: :request do
  let(:user)      { create(:aurelius_press_user) }
  let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www) }

  describe "POST /aurelius-press/likes (create)" do
    context "when authenticated" do
      before { sign_in user }

      it "creates a like and returns turbo stream" do
        expect {
          post aurelius_press_likes_path,
               params: { like: { likeable_type: "AureliusPress::Document::BlogPost", likeable_id: blog_post.id } },
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.to change(AureliusPress::Community::Like, :count).by(1)
        expect(response).to have_http_status(:ok)
      end

      it "is idempotent — cannot double-like" do
        create(:aurelius_press_community_like, user: user, likeable: blog_post)
        expect {
          post aurelius_press_likes_path,
               params: { like: { likeable_type: "AureliusPress::Document::BlogPost", likeable_id: blog_post.id } }
        }.not_to change(AureliusPress::Community::Like, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_likes_path,
             params: { like: { likeable_type: "AureliusPress::Document::BlogPost", likeable_id: blog_post.id } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/likes/:id (destroy)" do
    let!(:like) { create(:aurelius_press_community_like, user: user, likeable: blog_post) }

    context "when authenticated as the like owner" do
      before { sign_in user }

      it "destroys the like" do
        expect {
          delete aurelius_press_like_path(like),
                 headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.to change(AureliusPress::Community::Like, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in create(:aurelius_press_user) }

      it "is forbidden" do
        delete aurelius_press_like_path(like)
        expect(response).to have_http_status(:forbidden).or redirect_to(root_path)
      end
    end
  end

  describe "PATCH /aurelius-press/likes/:id (update)" do
    # Test once update action is implemented (backlog 5.1)
    # This is a placeholder — define expected semantics before writing this test.
    it "is defined (route exists)" do
      expect { patch aurelius_press_like_path(like) }.not_to raise_error(ActionController::RoutingError)
    end
  end
end
```

### 4c. Feature Test for Like Toggle (UI)

For the Turbo Stream visual feedback, one feature test per likeable surface is enough:

```ruby
# spec/features/aurelius_press/public/document/blog_post/likes_spec.rb
RSpec.feature "User can like a blog post", :js do
  let(:user)      { create(:aurelius_press_user) }
  let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www) }

  scenario "authenticated user likes and unlikes a post" do
    sign_in user
    visit aurelius_press_blog_post_path(blog_post)

    # Like
    click_button "Like"   # adjust selector to your actual UI
    expect(page).to have_content("1 like")

    # Unlike
    click_button "Unlike"
    expect(page).to have_content("0 likes")
  end

  scenario "guest cannot like a post" do
    visit aurelius_press_blog_post_path(blog_post)
    expect(page).not_to have_button("Like")
  end
end
```

---

## 5. Public Comments & Notes Testing (Phase 2)

### 5a. Layer Strategy

| What to test | Test type | Reason |
|---|---|---|
| Who can create/destroy | Policy spec | Fastest; pure Ruby |
| HTTP create/destroy + redirects | Request spec | No browser needed |
| Comment appears in page after submit | Feature spec (:js) | Turbo Stream update needs real browser |
| Access control (not-your-comment delete) | Request spec | Faster than feature |

### 5b. Feature Test Pattern

Follow the existing `crud_management_spec.rb` pattern exactly. One file per document type per fragment type:

```
spec/features/aurelius_press/public/document/
  blog_post/
    comments_spec.rb
    notes_spec.rb
  atomic_blog_post/
    comments_spec.rb
    notes_spec.rb
  page/
    comments_spec.rb
    notes_spec.rb
```

```ruby
# spec/features/aurelius_press/public/document/blog_post/comments_spec.rb
require "rails_helper"

RSpec.feature "User can manage comments on a Blog Post", :js do
  let(:user)      { create(:aurelius_press_user) }
  let(:author)    { create(:aurelius_press_user) }
  let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www, user: author) }
  let!(:existing_comment) { create(:aurelius_press_fragment_comment, commentable: blog_post, user: author, content: "First thought.") }

  scenario "CREATE - authenticated user can post a comment" do
    sign_in user
    visit aurelius_press_blog_post_path(blog_post)
    fill_in "Add a comment", with: "My new comment"
    click_button "Post Comment"
    expect(page).to have_content("My new comment")
    expect(AureliusPress::Fragment::Comment.count).to eq(2)
  end

  scenario "READ - guest can read existing comments" do
    visit aurelius_press_blog_post_path(blog_post)
    expect(page).to have_content("First thought.")
  end

  scenario "DELETE - user can delete their own comment" do
    sign_in user
    my_comment = create(:aurelius_press_fragment_comment, commentable: blog_post, user: user, content: "To be deleted.")
    visit aurelius_press_blog_post_path(blog_post)
    accept_confirm do
      click_link "Delete", href: aurelius_press_blog_post_comment_path(blog_post, my_comment)
    end
    expect(page).not_to have_content("To be deleted.")
    expect(AureliusPress::Fragment::Comment.count).to eq(1)
  end

  scenario "DELETE - user cannot delete someone else's comment" do
    sign_in user
    visit aurelius_press_blog_post_path(blog_post)
    # The delete link should not be rendered for comments the user doesn't own
    expect(page).not_to have_link("Delete", href: aurelius_press_blog_post_comment_path(blog_post, existing_comment))
  end

  scenario "guest cannot post a comment" do
    visit aurelius_press_blog_post_path(blog_post)
    expect(page).not_to have_field("Add a comment")
    expect(page).not_to have_button("Post Comment")
  end
end
```

### 5c. Request Spec for Comment HTTP Layer

```ruby
# spec/requests/aurelius_press/document/blog_posts/comments_spec.rb
require "rails_helper"

RSpec.describe "Blog Post Comments", type: :request do
  let(:user)      { create(:aurelius_press_user) }
  let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www) }

  describe "POST /aurelius-press/blog-posts/:blog_post_id/comments" do
    context "when authenticated" do
      before { sign_in user }

      it "creates a comment and redirects" do
        expect {
          post aurelius_press_blog_post_comments_path(blog_post),
               params: { comment: { content: "Test comment" } }
        }.to change(AureliusPress::Fragment::Comment, :count).by(1)
        expect(response).to redirect_to(aurelius_press_blog_post_path(blog_post))
      end

      it "rejects blank content" do
        expect {
          post aurelius_press_blog_post_comments_path(blog_post),
               params: { comment: { content: "" } }
        }.not_to change(AureliusPress::Fragment::Comment, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_blog_post_comments_path(blog_post),
             params: { comment: { content: "Test" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
```

---

## 6. Coverage Targets

| Layer | Current est. | Target | How to reach |
|---|---|---|---|
| Models | ~90% | 95% | Add JournalEntry behavioural tests |
| Policies | ~15% | 100% | All 11 Sprint 1 policy specs |
| Controllers / Request | ~50% | 80% | Request specs for all new public controllers |
| Feature (E2E) | ~40% | 70% | One CRUD feature spec per new controller |
| Routes | ~60% | 90% | Add routing specs for newly uncommented routes |

Enforce in CI via SimpleCov (already in Gemfile). Add a minimum threshold to `spec/spec_helper.rb` or `.simplecov`:

```ruby
# .simplecov
SimpleCov.start "rails" do
  minimum_coverage 80
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/vendor/"
end
```

---

## 7. Test Execution Order & CI Guidance

Run in this order to fail fast:

```bash
# 1. Fast (pure Ruby, no DB)
bundle exec rspec spec/models spec/policies --format progress

# 2. Medium (DB, no browser)
bundle exec rspec spec/requests spec/controllers spec/routing --format progress

# 3. Slow (browser required)
bundle exec rspec spec/features --format progress
```

In CI, run all layers but cache the fast layers separately so a model failure doesn't block a 10-minute feature suite.

---

## 8. Test Writing Rules (Project-Specific)

1. **Never mock the database** — this app already uses real DB + DatabaseCleaner. Keep it that way.
2. **`:js` only when Turbo Streams are tested** — for plain HTML redirects, drop the `:js` tag (10× faster).
3. **`create_list` max 3** — the FactoryBot guard in `rails_helper.rb` enforces this; it will raise if exceeded.
4. **State reset in loops** — the existing `crud_management_spec.rb` pattern shows how to handle this: `destroy_all` + recreate at the top of the loop body. Follow it exactly.
5. **Policy specs are pure Ruby** — no `sign_in`, no `visit`. Instantiate `described_class.new(user, record)` directly.
6. **One feature file per resource × action group** — `blog_post/comments_spec.rb`, `blog_post/notes_spec.rb` etc. Don't combine.
7. **Template assertions for view routing** — the existing feature specs assert `have_css("[template=\"Namespace::Controller#action\"]")`. Continue this pattern to catch routing bugs early.
8. **Always test the guest path** — every new public controller must have at least one example asserting unauthenticated access is handled correctly.
