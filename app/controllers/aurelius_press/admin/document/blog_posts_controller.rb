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
      redirect_to aurelius_press_admin_document_blog_post_path(@blog_post), notice: "Blog post created successfully."
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
      redirect_to aurelius_press_admin_document_blog_post_path(@blog_post), notice: "Blog post updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to aurelius_press_admin_document_blog_posts_path, notice: "Blog post deleted successfully."
  end

  private

  def blog_post_params
    params.require(:aurelius_press_document_blog_post).permit(
      :id, # integer, primary key
      :user_id, # references, the user who created the document
      :category_id, # references, the category the document belongs to
      :type, # string, used for Single Table Inheritance (STI)
      :title, # string, the title of the document
      :slug, # string, a URL-friendly version of the title (auto-generated)
      :subtitle, # string, a short descriptive subtitle
      :description, # string, the main content of the blog post
      :status, # enum, representing the document's status (default: draft)
      :visibility, # enum, representing who can see the document (default: private_to_owner)
      :published_at, # datetime, the date when the document was published (optional)
      :comments_enabled, # boolean, whether comments are enabled for the document (default: true)
      # :tags, # string, a comma-separated list of tags for the document
      # :content_blocks_attributes # nested attributes for content blocks
    )
  end

  private

  def set_blog_post
    @blog_post = AureliusPress::Document::BlogPost.find_by(slug: params[:id])
  end

  def set_tags_and_categories
    @tags = AureliusPress::Taxonomy::Tag.all
    @categories = AureliusPress::Taxonomy::Category.all
  end
end
