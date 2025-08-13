class AureliusPress::Document::AtomicBlogPostsController < AureliusPress::ApplicationController
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
    if @atomic_blog_post.save!
      redirect_to aurelius_press_atomic_blog_post_path(@atomic_blog_post), notice: "Atomic blog post was successfully created."
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
      redirect_to aurelius_press_atomic_blog_post_path(@atomic_blog_post), notice: "Atomic blog post was successfully updated."
    else
      set_tags_and_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @atomic_blog_post, :destroy?, policy_class: AureliusPress::DocumentPolicy
    @atomic_blog_post.destroy
    redirect_to aurelius_press_atomic_blog_posts_path, notice: "Atomic blog post was successfully deleted."
  end

  private

  # == Schema Information
  #
  # Table name: aurelius_press_documents
  #
  #  id               :bigint           not null, primary key
  #  user_id          :bigint           not null
  #  category_id      :bigint
  #  type             :string           not null
  #  slug             :string           not null
  #  title            :string           not null
  #  subtitle         :string
  #  description      :text
  #  status           :integer          default("draft"), not null
  #  visibility       :integer          default("private_to_owner"), not null
  #  published_at     :datetime
  #  created_at       :datetime         not null
  #  updated_at       :datetime         not null
  #  comments_enabled :boolean          default(FALSE), not null
  #  tags ???
  def atomic_blog_post_params
    params.require(:aurelius_press_document_atomic_blog_post).permit(
      :id,
      :user_id,
      :category_id,
      :slug,
      :title,
      :subtitle,
      :description,
      :status,
      :visibility,
      :published_at,
      :created_at,
      :updated_at,
      :comments_enabled,
      :content,
      :image_file,
      # tag_ids: [],
      # content_block_ids: []
    )
  end

  def set_atomic_blog_post
    @atomic_blog_post = AureliusPress::Document::AtomicBlogPost.find_by(slug: params[:id])
  end

  def set_tags_and_categories
    @tags = AureliusPress::Taxonomy::Tag.all
    @categories = AureliusPress::Taxonomy::Category.all
  end
end
