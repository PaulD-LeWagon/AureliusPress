class AureliusPress::Api::V1::Catalogue::QuotesController < AureliusPress::Api::V1::BaseController
  # Public API does not require admin authentication or authorization
  skip_before_action :authenticate_user!
  skip_before_action :authorize_admin_access

  def index
    @quotes = AureliusPress::Catalogue::Quote.includes(:source).all
    # Using simple rendering for now, could move to jbuilder/ams for complexity
    render json: @quotes.as_json(include: { source: { only: :title } })
  end

  def show
    @quote = AureliusPress::Catalogue::Quote.find_by!(slug: params[:id])
    render json: @quote.as_json(include: { source: { only: :title } })
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Quote not found" }, status: :not_found
  end
end
