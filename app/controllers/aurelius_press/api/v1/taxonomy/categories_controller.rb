class AureliusPress::Api::V1::Taxonomy::CategoriesController < AureliusPress::Api::V1::BaseController
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
end
