class AureliusPress::Taxonomy::CategoriesController < AureliusPress::ApplicationController
  def index
    @categories = AureliusPress::Taxonomy::Category.all.order(:name)
  end

  def show
    @category = AureliusPress::Taxonomy::Category.find_by!(slug: params[:slug])
  end
end
