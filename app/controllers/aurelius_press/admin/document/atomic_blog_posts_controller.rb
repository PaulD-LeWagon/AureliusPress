class AureliusPress::Admin::Document::AtomicBlogPostsController < AureliusPress::Admin::ApplicationController
  before_action :set_atomic_blog_post, only: [:show, :edit, :update, :destroy]
  before_action :set_tags_and_categories, only: [:new, :edit]

  def index
    @atomic_blog_posts = AureliusPress::Document::AtomicBlogPost.all
  end

  def show
  end

  def new
    @atomic_blog_post = AureliusPress::Document::AtomicBlogPost.new
  end

  def create
    @atomic_blog_post = AureliusPress::Document::AtomicBlogPost.new(atomic_blog_post_params)
    if @atomic_blog_post.save
      redirect_to aurelius_press_admin_document_atomic_blog_post_path(@atomic_blog_post), notice: 'Atomic blog post was successfully created.'
    else
      set_tags_and_categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @atomic_blog_post.update(atomic_blog_post_params)
      redirect_to aurelius_press_admin_document_atomic_blog_post_path(@atomic_blog_post), notice: 'Atomic blog post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @atomic_blog_post.destroy
    redirect_to aurelius_press_admin_document_atomic_blog_posts_url, notice: 'Atomic blog post was successfully destroyed.'
  end

  private

  def set_atomic_blog_post
    @atomic_blog_post = AureliusPress::Document::AtomicBlogPost.find_by!(slug: params[:id])
  end

  def set_tags_and_categories
    @tags = AureliusPress::Taxonomy::Tag.all
    @categories = AureliusPress::Taxonomy::Category.all
  end

  def atomic_blog_post_params
    params.require(:aurelius_press_document_atomic_blog_post).permit(
      :id, # integer, primary key
      :user_id, # references, the user who created the document
      :category_id, # references, the category the document belongs to
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
      :image_file # Active Storage attachment for images
    )
  end
end
