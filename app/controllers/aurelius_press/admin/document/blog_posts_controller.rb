class AureliusPress::Admin::Document::BlogPostsController < AureliusPress::Admin::ApplicationController
  before_action :set_blog_post, only: [:show, :edit, :update, :destroy]
  before_action :set_tags_and_categories, only: [:new, :edit]

  def index
    authorize AureliusPress::Document::BlogPost, :index?, policy_class: AureliusPress::DocumentPolicy
    @blog_posts = policy_scope(AureliusPress::Document::BlogPost, policy_scope_class: AureliusPress::DocumentPolicy::Scope)
  end

  def show
    authorize @blog_post, :show?, policy_class: AureliusPress::DocumentPolicy
  end

  def new
    @blog_post = AureliusPress::Document::BlogPost.new
    authorize @blog_post, :new?, policy_class: AureliusPress::DocumentPolicy
  end

  def create
    @blog_post = AureliusPress::Document::BlogPost.new(blog_post_params)
    authorize @blog_post, :create?, policy_class: AureliusPress::DocumentPolicy
    if @blog_post.save
      redirect_to aurelius_press_admin_document_blog_post_path(@blog_post), notice: action_was_successfully(:created)
    else
      set_tags_and_categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @blog_post, :edit?, policy_class: AureliusPress::DocumentPolicy
  end

  def update
    authorize @blog_post, :update?, policy_class: AureliusPress::DocumentPolicy
    if @blog_post.update(blog_post_params)
      redirect_to aurelius_press_admin_document_blog_post_path(@blog_post), notice: action_was_successfully(:updated)
    else
      set_tags_and_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to aurelius_press_admin_document_blog_posts_path, notice: action_was_successfully(:deleted)
  end

  private

  def blog_post_params
    # Create a mutable copy of the parameters hash
    raw_params = params.require(:aurelius_press_document_blog_post).dup
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
      :user_id,
      :type,
      :title,
      :slug,
      :subtitle,
      :description,
      :status,
      :visibility,
      :published_at,
      :comments_enabled,
      tagging_attributes: [
        :id,
        :tag_id,
        :_destroy,
        tag_attributes: [
          :id,
          :name,
          :slug,
        ], 
      ],
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
      content_blocks_attributes: [
        :id,
        :_destroy,
        :contentable_id,
        :contentable_type,
        :position,
        :html_id,
        :html_class,
        :data_attributes,
        # Permit the nested attributes via contentable
        contentable_attributes: [
          :id,
          :type,
          :content, # from RichTextBlock
          :image,   # from ImageBlock
          :caption, # from ImageBlock and GalleryImage
          :alignment,
          :link_text,
          :link_title,
          :link_class,
          :link_target,
          :link_url,
          :embed_code, # from VideoEmbedBlock
          :description,
          :video_url,
          :layout_type, # from GalleryBlock
          images: [],
        ],
      ],
    )
  end

  def set_blog_post
    @blog_post = AureliusPress::Document::BlogPost.find_by!(slug: params[:id])
  end

  def set_tags_and_categories
    @tags = AureliusPress::Taxonomy::Tag.all
    @categories = AureliusPress::Taxonomy::Category.all
  end

  def action_was_successfully(action)
    "Blog post #{action} successfully."
  end
end
