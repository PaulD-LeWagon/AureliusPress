class AureliusPress::Catalogue::QuotesController < AureliusPress::ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @quotes = AureliusPress::Catalogue::Quote.all
  end

  def show
    if params[:slug].present?
      @quote = AureliusPress::Catalogue::Quote.find_by(slug: params[:slug])
    elsif params[:id].present?
      @quote = AureliusPress::Catalogue::Quote.find(params[:id])
    else
      raise ActiveRecord::RecordNotFound, "No identifier provided"
    end
  end
end
