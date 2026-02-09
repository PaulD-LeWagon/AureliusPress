class AureliusPress::Admin::Catalogue::AuthorsController < AureliusPress::Admin::ApplicationController
  # before_action :authenticate_user! # Ensure user is authenticated
  # before_action :authorize_admin! # Ensure user is authorized
  before_action :set_author, only: %i[ show edit update destroy ]
  before_action :set_sources, only: %i[ new edit create update ]

  # GET /aurelius-press/admin/catalogue/authors
  def index
    authorize AureliusPress::Catalogue::Author, :index?, policy_class: AureliusPress::Admin::Catalogue::AuthorPolicy
    @authors = policy_scope(AureliusPress::Catalogue::Author, policy_scope_class: AureliusPress::Admin::Catalogue::AuthorPolicy::Scope)
  end

  # GET /aurelius-press/admin/catalogue/authors/:id
  def show
    authorize @author, :show?, policy_class: AureliusPress::Admin::Catalogue::AuthorPolicy
  end

  # GET /aurelius-press/admin/catalogue/authors/new
  def new
    @author = AureliusPress::Catalogue::Author.new
    authorize @author, :new?, policy_class: AureliusPress::Admin::Catalogue::AuthorPolicy
  end

  # POST /aurelius-press/admin/catalogue/authors
  def create
    @author = AureliusPress::Catalogue::Author.new(author_params)
    authorize @author, :create?, policy_class: AureliusPress::Admin::Catalogue::AuthorPolicy

    if @author.save
      redirect_to aurelius_press_admin_catalogue_author_path(@author), notice: action_was_successfully(:created), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /aurelius-press/admin/catalogue/authors/:id/edit
  def edit
    authorize @author, :edit?, policy_class: AureliusPress::Admin::Catalogue::AuthorPolicy
  end

  # PATCH/PUT /aurelius-press/admin/catalogue/authors/:id
  def update
    authorize @author, :update?, policy_class: AureliusPress::Admin::Catalogue::AuthorPolicy
    if @author.update(author_params)
      redirect_to aurelius_press_admin_catalogue_author_path(@author), notice: action_was_successfully(:updated), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /aurelius-press/admin/catalogue/authors/:id
  def destroy
    authorize @author, :destroy?, policy_class: AureliusPress::Admin::Catalogue::AuthorPolicy
    @author.destroy!
    redirect_to aurelius_press_admin_catalogue_authors_url, notice: action_was_successfully(:deleted), status: :see_other
  end

  private

  def action_was_successfully(action)
    "Author #{action} successfully."
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_author
    @author = AureliusPress::Catalogue::Author.find_by!(slug: params[:id])
  end

  def set_sources
    @sources = AureliusPress::Catalogue::Source.ordered_by_type.ordered_by_title
  end

  # Only allow a list of trusted parameters through.
  def author_params
    params.require(:aurelius_press_catalogue_author).permit(
      :id,
      :image,
      :name,
      :slug,
      :bio,
      :birth_date,
      :death_date,
      authorships_attributes: [
        :id,
        :source_id,
        :role,
        :_destroy
      ]
    )
  end
end
