class AureliusPress::Taxonomy::TagsController < AureliusPress::ApplicationController
  def index
    @tags = AureliusPress::Taxonomy::Tag.all.order(:name)
  end

  def show
    @tag = AureliusPress::Taxonomy::Tag.find_by!(slug: params[:slug])
  end
end
