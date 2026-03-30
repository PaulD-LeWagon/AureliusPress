class AureliusPress::Api::V1::Taxonomy::TagsController < AureliusPress::Api::V1::BaseController
  def index
    if params[:q].present?
      @tags = AureliusPress::Taxonomy::Tag.where("name ILIKE ?", "%#{params[:q]}%")
    else
      @tags = AureliusPress::Taxonomy::Tag.all.limit(20)
    end
    render json: @tags
  end

  def create
    @tag = AureliusPress::Taxonomy::Tag.new(tag_params)
    if @tag.save
      render json: @tag, status: :created
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
