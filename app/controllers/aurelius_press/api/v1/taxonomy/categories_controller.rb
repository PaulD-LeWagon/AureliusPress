class AureliusPress::Api::V1::Taxonomy::CategoriesController < AureliusPress::Api::V1::BaseController
  # Allow all authenticated users to search for categories (needed for AtomicBlogPost)
  skip_before_action :authorize_admin_access, only: [:index, :create]

  def index
    puts "DEBUG: API SEARCH PARAMS: #{params.inspect}"
    if params[:q].present?
      @categories = AureliusPress::Taxonomy::Category.where("name ILIKE ?", "%#{params[:q]}%")
    else
      @categories = AureliusPress::Taxonomy::Category.all.limit(20)
    end
    puts "DEBUG: API FOUND: #{@categories.count} categories"
    render json: @categories
  end

  def create
    @category = AureliusPress::Taxonomy::Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
