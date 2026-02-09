class AureliusPress::Admin::Catalogue::SourcesController < AureliusPress::Admin::ApplicationController
  before_action :set_source, only: %i[ show edit update destroy ]
  before_action :set_authors, only: %i[ new edit create update ]

  # GET /aurelius-press/admin/catalogue/sources
  def index
    @sources = AureliusPress::Catalogue::Source.all
  end

  # GET /aurelius-press/admin/catalogue/sources/:id
  def show
  end

  # GET /aurelius-press/admin/catalogue/sources/new
  def new
    @source = AureliusPress::Catalogue::Source.new
  end

  # GET /aurelius-press/admin/catalogue/sources/:id/edit
  def edit
  end

  # POST /aurelius-press/admin/catalogue/sources
  def create
    @source = AureliusPress::Catalogue::Source.new(source_params)

    if @source.save
      redirect_to aurelius_press_admin_catalogue_source_path(@source), notice: "Source was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aurelius-press/admin/catalogue/sources/:id
  def update
    if @source.update(source_params)
      redirect_to aurelius_press_admin_catalogue_source_path(@source), notice: "Source was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /aurelius-press/admin/catalogue/sources/:id
  def destroy
    @source.destroy!
    redirect_to aurelius_press_admin_catalogue_sources_url, notice: "Source was successfully destroyed.", status: :see_other
  end

  private

  def set_source
    @source = AureliusPress::Catalogue::Source.find_by!(slug:params[:id])
  end

  def set_authors
    @authors = AureliusPress::Catalogue::Author.all
  end

  def source_params
    params.require(:aurelius_press_catalogue_source).permit(
      :id,
      :slug,
      :title,
      :description,
      :author_id,
      :source_type,
      :date,
      :isbn,
      :cover_image,
      :comments_enabled,
      authorships_attributes: [:id, :author_id, :role, :_destroy],
      affiliate_links_attributes: [:id, :url, :text, :description, :_destroy]
    )
  end
end
