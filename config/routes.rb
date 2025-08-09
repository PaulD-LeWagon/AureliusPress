Rails.application.routes.draw do
  # =====================================================================
  # Devise routes for user authentication
  # This sets up the routes for user sessions, registrations, passwords, etc.
  # The class_name option specifies that the User model is in the AureliusPress namespace.
  # The path option customizes the URL prefix for these routes.
  # =====================================================================
  devise_for :users, class_name: "AureliusPress::User", path: "aurelius-press/users"
  # =====================================================================
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # =====================================================================
  # Top-level AureliusPress namespace
  # This acts as the container for all features within the AureliusPress application.
  # The `path: 'aurelius-press'` ensures URLs are clean (e.g., /aurelius-press/...)
  # =====================================================================
  namespace :aurelius_press, path: "aurelius-press" do
    # --- Admin/CMS Routes ---
    # These routes are for managing the catalogue content by administrators.
    # They map to controllers like AureliusPress::Admin::Catalogue::AuthorsController
    namespace :admin do
      # resources :settings # For site-wide configurations
      # All CRUD actions (index, show, new, create, edit, update, destroy)
      namespace :document do
        resources :atomic_blog_posts, path: "atomic-blog-posts" do
          resources :comments
          resources :notes do
            resources :comments
          end
        end
        resources :blog_posts, path: "blog-posts" do
          resources :comments
          resources :notes do
            resources :comments
          end
        end
        resources :pages do
          resources :comments
          resources :notes do
            resources :comments
          end
        end
      end
      namespace :fragment do
        resources :notes
        resources :comments
      end
      namespace :catalogue do
        resources :authors
        resources :sources
        resources :quotes
      end
      namespace :taxonomy do
        resources :tags
        resources :categories
      end
      namespace :community do
        resources :likes
        resources :groups
        # resources :group_memberships
      end
      # namespace :authorship do
      # resources :roles
      # resources :permissions
      # end
      resources :users
    end
    # --- Public-facing (Non-Admin) Routes ---
    namespace :catalogue do
      resources :authors, only: [:index, :show], param: :slug, constraints: { slug: /(?!new|edit)[a-zA-Z0-9\-_]+/ }
      resources :sources, only: [:index, :show], param: :slug, constraints: { slug: /(?!new|edit)[a-zA-Z0-9\-_]+/ }
      resources :quotes, only: [:index, :show], param: :slug, constraints: { slug: /(?!new|edit)[a-zA-Z0-9\-_]+/ }
    end
    # resources :categories, only: [:create, :update], param: :slug, constraints: { slug: /(?!new|edit)[a-zA-Z0-9\-_]+/ }
    # resources :tags, only: [:create, :update], param: :slug, constraints: { slug: /(?!new|edit)[a-zA-Z0-9\-_]+/ }
    # # Flattened Likes for ALL likeable objects
    # resources :likes, only: [:create, :destroy, :update]
    # Define routes for users
    # resources :users, only: [:show, :edit, :update]
    # Concrete Document Routes
    # Define routes for Pages
    resources :pages do
      resources :notes do # Notes on Pages (pages/:page_id/notes)
        resources :comments # Comments on Notes (pages/:page_id/notes/:note_id/comments)
      end
    end
    # Define routes for Atomic Blog Posts
    resources :atomic_blog_posts, path: "atomic-blog-posts" do
      resources :comments # Comments on Atomic Blog Posts (atomic_blog_posts/:atomic_blog_post_id/comments)
      resources :notes do # Notes on Atomic Blog Posts (atomic_blog_posts/:atomic_blog_post_id/notes)
        resources :comments # Comments on Notes (atomic_blog_posts/:atomic_blog_post_id/notes/:note_id/comments)
      end
    end
    # Define routes for Blog Posts
    resources :blog_posts, path: "blog-posts" do
      resources :comments # Comments on Blog Posts (blog_posts/:blog_post_id/comments)
      resources :notes do # Notes on Blog Posts (blog_posts/:blog_post_id/notes)
        resources :comments # Comments on Notes (blog_posts/:blog_post_id/notes/:note_id/comments)
      end
    end
  end
  # =====================================================================
  # Top-level application routes (outside of AureliusPress namespace)
  # These are for general application pages like homepage, auth, etc.
  # =====================================================================
  # Front Door
  get "home" => "home#index", as: :home
  root "home#index"
end
