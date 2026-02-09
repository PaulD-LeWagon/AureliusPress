class AureliusPress::Admin::Document::AtomicBlogPostsController < AureliusPress::Admin::ApplicationController
  before_action :set_atomic_blog_post, only: [:show, :edit, :update, :destroy]
  before_action :set_tags_and_categories, only: [:new, :edit]

  def index
    authorize AureliusPress::Document::AtomicBlogPost, :index?, policy_class: AureliusPress::DocumentPolicy
    @atomic_blog_posts = policy_scope(AureliusPress::Document::AtomicBlogPost, policy_scope_class: AureliusPress::DocumentPolicy::Scope)
  end

  def show
    authorize @atomic_blog_post, :show?, policy_class: AureliusPress::DocumentPolicy
  end

  def new
    @atomic_blog_post = AureliusPress::Document::AtomicBlogPost.new
    authorize @atomic_blog_post, :new?, policy_class: AureliusPress::DocumentPolicy
  end

  def create
    @atomic_blog_post = AureliusPress::Document::AtomicBlogPost.new(atomic_blog_post_params)
    authorize @atomic_blog_post, :create?, policy_class: AureliusPress::DocumentPolicy
    if @atomic_blog_post.save
      redirect_to aurelius_press_admin_document_atomic_blog_post_path(@atomic_blog_post), notice: action_was_successfully(:created)
    else
      set_tags_and_categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @atomic_blog_post, :edit?, policy_class: AureliusPress::DocumentPolicy
  end

  def update
    authorize @atomic_blog_post, :update?, policy_class: AureliusPress::DocumentPolicy
    if @atomic_blog_post.update(atomic_blog_post_params)
      redirect_to aurelius_press_admin_document_atomic_blog_post_path(@atomic_blog_post), notice: action_was_successfully(:updated)
    else
      set_tags_and_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @atomic_blog_post, :destroy?, policy_class: AureliusPress::DocumentPolicy
    @atomic_blog_post.destroy
    redirect_to aurelius_press_admin_document_atomic_blog_posts_url, notice: action_was_successfully(:deleted)
  end

  private

  def set_atomic_blog_post
    @atomic_blog_post = AureliusPress::Document::AtomicBlogPost.find_by!(slug: params[:id])
  end

  def set_tags_and_categories
    @tags = AureliusPress::Taxonomy::Tag.all
    @categories = AureliusPress::Taxonomy::Category.all
  end

  def action_was_successfully(action)
    "Atomic blog post #{action} successfully."
  end

  def atomic_blog_post_params
    # Create a mutable copy of the parameters hash
    raw_params = params.require(:aurelius_press_document_atomic_blog_post).dup
    # Safely access categorization_attributes
    categorization_attrs = raw_params[:categorization_attributes]
    if categorization_attrs.present?
      # Scenario 1: User is attempting to create a new category
      if categorization_attrs[:category_attributes]&.dig(:name).present?
        # Ensure both category_id (from dropdown) and id within category_attributes are removed.
        # This forces the creation of a *new* Category.
        categorization_attrs.delete(:category_id)
        categorization_attrs[:category_attributes].delete(:id) if categorization_attrs[:category_attributes][:id].present?
      elsif categorization_attrs[:category_id].present?
        # Scenario 2: User has selected an existing category from the dropdown
        # If an existing category_id is selected, discard any nested category_attributes.
        # This prevents conflicting attempts to create/update a nested category.
        categorization_attrs.delete(:category_attributes)
      end
    end
    # Now, permit the filtered parameters
    raw_params.permit(
      :id, # integer, primary key
      :user_id, # references, the user who created the document
      :type, # string, used for Single Table Inheritance (STI)
      :title, # string, the title of the document
      :slug, # string, a URL-friendly version of the title (auto-generated)
      :subtitle, # string, a short descriptive subtitle
      :description, # text, a longer description of the document
      :status, # enum, representing the document's status (default: draft)
      :visibility, # enum, representing who can see the document (default: private_to_owner)
      :published_at, # datetime, the date when the document was published (optional)
      :comments_enabled, # boolean, whether comments are enabled for the document (default: true)
      :content, # Action Text rich text content
      :image_file, # Active Storage attachment for images
      :comments_enabled,
      categorization_attributes: [
        :id,
        :category_id,
        :_destroy,
        category_attributes: [
          :id,
          :name,
          :slug,
        ],
      ],
      # :tags
    )
  end
end
