class AureliusPress::Admin::Document::PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

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
    @page = AureliusPress::Document::Page.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to aurelius_press_admin_document_pages_path, alert: "Page not found."
  end

  def page_params
    params.require(:aurelius_press_document_page).permit(
      :user_id,
      :category_id,
      :type,
      :title,
      :slug,
      :subtitle,
      :status,
      :visibility,
    )
  end
end
