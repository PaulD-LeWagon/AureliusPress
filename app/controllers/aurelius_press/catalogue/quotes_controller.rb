class AureliusPress::Catalogue::QuotesController < AureliusPress::ApplicationController
  def index
    @quotes = Quote.all
  end

  def show
    @quote = Quote.find(params[:id])
  end
end
