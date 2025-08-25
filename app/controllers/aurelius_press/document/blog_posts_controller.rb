class AureliusPress::Document::BlogPostsController < AureliusPress::ApplicationController
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
      redirect_to aurelius_press_blog_post_path(@blog_post), notice: action_was_successfully(:created)
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
      redirect_to aurelius_press_blog_post_path(@blog_post), notice: action_was_successfully(:updated)
    else
      set_tags_and_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @blog_post, :destroy?, policy_class: AureliusPress::DocumentPolicy
    @blog_post.destroy
    redirect_to aurelius_press_blog_posts_path, notice: action_was_successfully(:deleted)
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
  def blog_post_params
    params.require(:aurelius_press_document_blog_post).permit(
      :id,
      :user_id,
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
      :category_id,
      # tag_ids: [],
      # content_block_ids: []
    )
  end

  def set_blog_post
    @blog_post = AureliusPress::Document::BlogPost.find_by(slug: params[:id])
  end

  def set_tags_and_categories
    @tags = AureliusPress::Taxonomy::Tag.all
    @categories = AureliusPress::Taxonomy::Category.all
  end

  def action_was_successfully(action)
    "Blog post #{action} successfully."
  end
end
