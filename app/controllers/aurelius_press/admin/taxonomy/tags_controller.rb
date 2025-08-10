class AureliusPress::Admin::Taxonomy::TagsController < AureliusPress::Admin::ApplicationController
  before_action :set_tag, only: %i[ show edit update destroy ]

  # GET /aurelius_press/admin/taxonomy/tags
  def index
    @tags = AureliusPress::Taxonomy::Tag.all
  end

  # GET /aurelius_press/admin/taxonomy/tags/1
  def show
    # @tag is set by before_action
  end

  # GET /aurelius_press/admin/taxonomy/tags/new
  def new
    @tag = AureliusPress::Taxonomy::Tag.new
  end

  # GET /aurelius_press/admin/taxonomy/tags/1/edit
  def edit
    # @tag is set by before_action
  end

  # POST /aurelius_press/admin/taxonomy/tags
  def create
    @tag = AureliusPress::Taxonomy::Tag.new(tag_params)

    if @tag.save
      redirect_to aurelius_press_admin_taxonomy_tag_path(@tag), notice: "Tag was successfully created."
    else
      render :new, status: :unprocessable_entity # Uses the 'new' template with validation errors
    end
  end

  # PATCH/PUT /aurelius_press/admin/taxonomy/tags/1
  def update
    if @tag.update(tag_params)
      redirect_to aurelius_press_admin_taxonomy_tag_path(@tag), notice: "Tag was successfully updated."
    else
      render :edit, status: :unprocessable_entity # Uses the 'edit' template with validation errors
    end
  end

  # DELETE /aurelius_press/admin/taxonomy/tags/1
  def destroy
    @tag.destroy! # Use destroy! for immediate errors if deletion fails
    redirect_to aurelius_press_admin_taxonomy_tags_url, notice: "Tag was successfully destroyed."
  end

  private

  def set_tag
    @tag = AureliusPress::Taxonomy::Tag.find(params[:id])
  end

  def tag_params
    params.require(:aurelius_press_taxonomy_tag).permit(:name, :slug)
  end
end
