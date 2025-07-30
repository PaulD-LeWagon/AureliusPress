class AureliusPress::Admin::Document::BlogPostsController < ApplicationController
  before_action :set_blog_post, only: [:show, :edit, :update, :destroy]

  def index
    @blog_posts = AureliusPress::Document::BlogPost.all
  end

  def show
  end

  def new
    @blog_post = AureliusPress::Document::BlogPost.new
  end

  def create
    @blog_post = AureliusPress::Document::BlogPost.new(blog_post_params)
    if @blog_post.save
      redirect_to aurelius_press_admin_document_blog_post_path(@blog_post), notice: "Blog post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
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
      :status, # enum, representing the document's status (default: draft)
      :visibility, # enum, representing who can see the document (default: private_to_owner)
      :published_at, # datetime, the date when the document was published (optional)
      :comments_enabled, # boolean, whether comments are enabled for the document (default: true)
    )
  end

  def set_blog_post
    @blog_post = AureliusPress::Document::BlogPost.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to aurelius_press_admin_document_blog_posts_path, alert: "Blog post not found."
  end
end
