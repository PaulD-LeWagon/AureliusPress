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
          resources :comments, only: [:create, :update, :destroy]
          resources :notes, only: [:create, :update, :destroy] do
            resources :comments, only: [:create, :update, :destroy]
          end
        end
        resources :blog_posts, path: "blog-posts" do
          resources :content_blocks, path: "cb", only: [:create, :update, :destroy] do
            resources :comments, only: [:create, :update, :destroy]
            resources :notes, only: [:create, :update, :destroy] do
              resources :comments, only: [:create, :update, :destroy]
            end
          end
          resources :comments, only: [:create, :update, :destroy]
          resources :notes, only: [:create, :update, :destroy] do
            resources :comments, only: [:create, :update, :destroy]
          end
        end
        resources :pages do
          resources :content_blocks, path: "cb", only: [:create, :update, :destroy] do
            resources :comments, only: [:create, :update, :destroy]
            resources :notes, only: [:create, :update, :destroy] do
              resources :comments, only: [:create, :update, :destroy]
            end
          end
          resources :notes, only: [:create, :update, :destroy] do
            resources :comments, only: [:create, :update, :destroy]
          end
        end
      end
      namespace :fragment do
        resources :comments, only: [:index, :show, :destroy]
        resources :notes, only: [:index, :show, :destroy]
      end
      namespace :catalogue do
        resources :authors do
          resources :comments, only: [:index, :show, :destroy]
          resources :notes, only: [:index, :show, :destroy] do
            resources :comments, only: [:index, :show, :destroy]
          end
        end
        resources :sources do
          resources :comments, only: [:index, :show, :destroy]
          resources :notes, only: [:index, :show, :destroy] do
            resources :comments, only: [:index, :show, :destroy]
          end
        end
        resources :quotes do
          resources :comments, only: [:index, :show, :destroy]
          resources :notes, only: [:index, :show, :destroy] do
            resources :comments, only: [:index, :show, :destroy]
          end
        end
      end
      namespace :taxonomy do
        resources :tags
        resources :categories
      end
      namespace :community do
        resources :likes
        # resources :reactions
        resources :groups
        # resources :group_memberships
      end
      resources :users
    end
    # --- Public-facing (Non-Admin) Routes ---
    namespace :catalogue do
      resources :authors, only: [:index, :show], param: :slug, constraints: { slug: /(?!new|edit)[a-zA-Z0-9\-_]+/ } do
        resources :comments, only: [:create, :update, :destroy]
        resources :notes, only: [:create, :update, :destroy] do
          resources :comments, only: [:create, :update, :destroy]
        end
      end
      resources :sources, only: [:index, :show], param: :slug, constraints: { slug: /(?!new|edit)[a-zA-Z0-9\-_]+/ } do
        resources :comments, only: [:create, :update, :destroy]
        resources :notes, only: [:create, :update, :destroy] do
          resources :comments, only: [:create, :update, :destroy]
        end
      end
      resources :quotes, only: [:index, :show], param: :slug, constraints: { slug: /(?!new|edit)[a-zA-Z0-9\-_]+/ } do
        resources :comments, only: [:create, :update, :destroy]
        resources :notes, only: [:create, :update, :destroy] do
          resources :comments, only: [:create, :update, :destroy]
        end
      end
    end
    # Flattened Likes for ALL likeable objects
    resources :likes, only: [:create, :destroy, :update]
    # Define routes for users
    resources :users, only: [:show, :edit, :update]
    ## Concrete Document Routes
    # Define routes for Atomic Blog Posts
    resources :atomic_blog_posts, path: "atomic-blog-posts", module: "document" do
      resources :comments, only: [:create, :update, :destroy]
      resources :notes, only: [:create, :update, :destroy] do
        resources :comments, only: [:create, :update, :destroy]
      end
    end
    # Define routes for Blog Posts
    resources :blog_posts, path: "blog-posts", module: "document" do
      resources :content_blocks, path: "cb", only: [:create, :update, :destroy] do
        resources :comments, only: [:create, :update, :destroy]
        resources :notes, only: [:create, :update, :destroy] do
          resources :comments, only: [:create, :update, :destroy]
        end
      end
      resources :comments, only: [:create, :update, :destroy]
      resources :notes, only: [:create, :update, :destroy] do
        resources :comments, only: [:create, :update, :destroy]
      end
    end
    # Define routes for Pages
    resources :pages, module: "document" do
      resources :content_blocks, path: "cb", only: [:create, :update, :destroy] do
        resources :comments, only: [:create, :update, :destroy]
        resources :notes, only: [:create, :update, :destroy] do
          resources :comments, only: [:create, :update, :destroy]
        end
      end
      resources :notes, only: [:create, :update, :destroy] do
        resources :comments, only: [:create, :update, :destroy]
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
