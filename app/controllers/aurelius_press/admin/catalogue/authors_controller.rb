class AureliusPress::Admin::Catalogue::AuthorsController < AureliusPress::Admin::ApplicationController
  # before_action :authenticate_user! # Ensure user is authenticated
  # before_action :authorize_admin! # Ensure user is authorized
  before_action :set_author, only: %i[ show edit update destroy ]

  # GET /aurelius-press/admin/catalogue/authors
  def index
    @authors = AureliusPress::Catalogue::Author.all
  end

  # GET /aurelius-press/admin/catalogue/authors/:id
  def show
  end

  # GET /aurelius-press/admin/catalogue/authors/new
  def new
    @author = AureliusPress::Catalogue::Author.new
  end

  # GET /aurelius-press/admin/catalogue/authors/:id/edit
  def edit
  end

  # POST /aurelius-press/admin/catalogue/authors
  def create
    @author = AureliusPress::Catalogue::Author.new(author_params)

    if @author.save
      redirect_to aurelius_press_admin_catalogue_author_path(@author), notice: "Author was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aurelius-press/admin/catalogue/authors/:id
  def update
    if @author.update(author_params)
      redirect_to aurelius_press_admin_catalogue_author_path(@author), notice: "Author was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /aurelius-press/admin/catalogue/authors/:id
  def destroy
    @author.destroy!
    redirect_to aurelius_press_admin_catalogue_authors_url, notice: "Author was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_author
    @author = AureliusPress::Catalogue::Author.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def author_params
    params.require(:aurelius_press_catalogue_author).permit(:id, :name, :bio, :slug)
  end
end
