class AureliusPress::Catalogue::AuthorsController < AureliusPress::ApplicationController
  def index
    @authors = AureliusPress::Catalogue::Author.all
  end

  def show
    @author = AureliusPress::Catalogue::Author.find(params[:id])
  end
end
