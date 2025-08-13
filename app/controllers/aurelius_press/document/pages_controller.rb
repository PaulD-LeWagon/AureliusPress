class AureliusPress::Document::PagesController < AureliusPress::ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_tags_and_categories, only: [:new, :edit]
  def index
    authorize AureliusPress::Document::Page, :index?, policy_class: AureliusPress::DocumentPolicy
    @pages = policy_scope(AureliusPress::Document::Page, policy_scope_class: AureliusPress::DocumentPolicy::Scope)
  end

  def show
    authorize @page, :show?, policy_class: AureliusPress::DocumentPolicy
  end

  def new
    @page = AureliusPress::Document::Page.new
    authorize @page, :new?, policy_class: AureliusPress::DocumentPolicy
  end

  def create
    @page = AureliusPress::Document::Page.new(page_params)
    authorize @page, :create?, policy_class: AureliusPress::DocumentPolicy

    if @page.save
      redirect_to aurelius_press_page_path(@page), notice: "Page was successfully created."
    else
      set_tags_and_categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @page, :edit?, policy_class: AureliusPress::DocumentPolicy
  end

  def update
    authorize @page, :update?, policy_class: AureliusPress::DocumentPolicy

    if @page.update(page_params)
      redirect_to aurelius_press_page_path(@page), notice: "Page was successfully updated."
    else
      set_tags_and_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @page, :destroy?, policy_class: AureliusPress::DocumentPolicy
    @page.destroy
    redirect_to aurelius_press_pages_path, notice: "Page was successfully deleted."
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
  def page_params
    params.require(:aurelius_press_document_page).permit(
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
      # tag_ids: [], ???
      # content_block_ids: [] ???
    )
  end

  def set_page
    @page = AureliusPress::Document::Page.find_by(slug: params[:id])
  end

  def set_tags_and_categories
    @tags = AureliusPress::Taxonomy::Tag.all
    @categories = AureliusPress::Taxonomy::Category.all
  end
end
