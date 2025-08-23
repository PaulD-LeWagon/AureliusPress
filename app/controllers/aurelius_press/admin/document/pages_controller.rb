class AureliusPress::Admin::Document::PagesController < AureliusPress::Admin::ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_tags_and_categories, only: [:show, :new, :edit]

  def index
    # The policy scope will filter the documents based on the current user's role.
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
      redirect_to aurelius_press_admin_document_page_path(@page), notice: "Page was successfully created."
    else
      raise
      set_tags_and_categories
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @page, :edit?, policy_class: AureliusPress::DocumentPolicy
  end

  def update
    authorize @page, :update?, policy_class: AureliusPress::DocumentPolicy
    # raise
    if @page.update(page_params)
      redirect_to aurelius_press_admin_document_page_path(@page), notice: "Page was successfully updated."
    else
      raise "Validation errors: #{@page.errors.full_messages}"
      set_tags_and_categories
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @page, :destroy?, policy_class: AureliusPress::DocumentPolicy
    @page.destroy
    redirect_to aurelius_press_admin_document_pages_path, notice: "Page was successfully destroyed."
  end

  private

  def set_page
    @page = AureliusPress::Document::Page.find_by!(slug: params[:id])
  end

  def set_tags_and_categories
    # AureliusPress::Taxonomy::Tag.all
    @tags = "not, yet, implemented"
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

  # app/controllers/aurelius_press/admin/document/pages_controller.rb

  # app/controllers/aurelius_press/admin/document/pages_controller.rb

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
      :published_at,
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
          images: []
        ],
      ],
    )
  end

  # def page_params
  #   params.require(:aurelius_press_document_page).permit(
  #     :id,
  #     :user_id,
  #     :category_id,
  #     :type,
  #     :title,
  #     :slug,
  #     :subtitle,
  #     :description,
  #     :status,
  #     :visibility,
  #     content_blocks_attributes: [
  #       :id,
  #       :_destroy,
  #       :contentable_id,
  #       :contentable_type,
  #       :position,
  #       :html_id,
  #       :html_class,
  #       :data_attributes,
  #       # Permit contentable attributes to catch all delegated type attributes
  #       contentable: [
  #         :id,
  #         :type, # The type of the delegated class (e.g., RichTextBlock)
  #         :content, # from RichTextBlock
  #         :image,   # from ImageBlock
  #         :caption, # from ImageBlock and GalleryImage
  #         :alignment,
  #         :link_title,
  #         :link_class,
  #         :link_target,
  #         :link_url,
  #         :embed_code, # from VideoEmbedBlock
  #         :description,
  #         :video_url,
  #         :layout_type, # from GalleryBlock
  #         gallery_images_attributes: [:id, :_destroy, :image, :caption, :position],
  #       ],
  #     ],
  #   )
  # end

  # def page_params
  #   params.require(:aurelius_press_document_page).permit(
  #     :id,
  #     :user_id,
  #     :category_id,
  #     :type,
  #     :title,
  #     :slug,
  #     :subtitle,
  #     :description,
  #     :status,
  #     :visibility,
  #     # :tags,
  #     content_blocks_attributes: [
  #       :id,
  #       :_destroy,
  #       :contentable_id,
  #       :contentable_type,
  #       :position,
  #       :html_id,
  #       :html_class,
  #       :data_attributes,
  #       rich_text_block_attributes: [:id, :_destroy, :content],
  #       image_block_attributes: [:id, :_destroy, :caption, :alignment, :link_title, :link_class, :link_target, :link_url],
  #       video_embed_block_attributes: [:id, :_destroy, :embed_code, :description, :video_url],
  #       gallery_block_attributes: [
  #         :id,
  #         :_destroy,
  #         :layout_type,
  #         gallery_images_attributes: [:id, :_destroy, :image, :caption, :position],
  #       ],
  #     ],
  #   )
  # end
end
