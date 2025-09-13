class AureliusPress::Catalogue::QuotesController < AureliusPress::ApplicationController
  def index
    @quotes = AureliusPress::Catalogue::Quote.all
  end

  def show
    @quote = AureliusPress::Catalogue::Quote.find(params[:id])
  end
end
