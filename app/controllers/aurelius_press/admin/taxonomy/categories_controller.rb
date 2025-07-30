class AureliusPress::Admin::Taxonomy::CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /aurelius_press/admin/taxonomy/categories
  def index
    @categories = AureliusPress::Taxonomy::Category.all
  end

  # GET /aurelius_press/admin/taxonomy/categories/1
  def show
    # @category is set by before_action
  end

  # GET /aurelius_press/admin/taxonomy/categories/new
  def new
    @category = AureliusPress::Taxonomy::Category.new
  end

  # GET /aurelius_press/admin/taxonomy/categories/1/edit
  def edit
    # @category is set by before_action
  end

  # POST /aurelius_press/admin/taxonomy/categories
  def create
    @category = AureliusPress::Taxonomy::Category.new(category_params)

    if @category.save
      redirect_to aurelius_press_admin_taxonomy_category_path(@category), notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity # Uses the 'new' template with validation errors
    end
  end

  # PATCH/PUT /aurelius_press/admin/taxonomy/categories/1
  def update
    if @category.update(category_params)
      redirect_to aurelius_press_admin_taxonomy_category_path(@category), notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity # Uses the 'edit' template with validation errors
    end
  end

  # DELETE /aurelius_press/admin/taxonomy/categories/1
  def destroy
    @category.destroy! # Use destroy! for immediate errors if deletion fails
    redirect_to aurelius_press_admin_taxonomy_categories_url, notice: "Category was successfully destroyed."
  end

  private

  def set_category
    @category = AureliusPress::Taxonomy::Category.find(params[:id])
  end

  def category_params
    params.require(:aurelius_press_taxonomy_category).permit(:name, :slug)
  end
end
