class AureliusPress::Catalogue::SourcesController < AureliusPress::ApplicationController
  def index
    @sources = AureliusPress::Catalogue::Source.all
  end

  def show
    @source = AureliusPress::Catalogue::Source.find(params[:id])
  end
end
