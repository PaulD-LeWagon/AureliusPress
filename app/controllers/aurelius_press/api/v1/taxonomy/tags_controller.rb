class AureliusPress::Api::V1::Taxonomy::TagsController < AureliusPress::Api::V1::BaseController
  # Allow all authenticated users to search and create tags (needed for AtomicBlogPost)
  skip_before_action :authorize_admin_access, only: [:index, :create]

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
