class AureliusPress::Admin::Document::PagesController < AureliusPress::Admin::ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_tags_and_categories, only: [:new, :edit]

  def index
    @pages = AureliusPress::Document::Page.all
  end

  def show
  end

  def new
    @page = AureliusPress::Document::Page.new
  end

  def create
    @page = AureliusPress::Document::Page.new(page_params)
    if @page.save
      redirect_to aurelius_press_admin_document_page_path(@page), notice: "Page was successfully created."
    else
      set_tags_and_categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to aurelius_press_admin_document_page_path(@page), notice: "Page was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @page.destroy
    redirect_to aurelius_press_admin_document_pages_path, notice: "Page was successfully destroyed."
  end

  private

  def set_page
    @page = AureliusPress::Document::Page.find_by!(slug: params[:id])
  end

  def set_tags_and_categories
    @tags = AureliusPress::Taxonomy::Tag.all
    @categories = AureliusPress::Taxonomy::Category.all
  end

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
  #  tags             :text             default([]), not null, array: true

  def page_params
    params.require(:aurelius_press_document_page).permit(
      :id,
      :user_id,
      :category_id,
      :type,
      :title,
      :slug,
      :subtitle,
      :description,
      :status,
      :visibility,
    )
  end
end
