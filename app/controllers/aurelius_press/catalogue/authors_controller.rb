class AureliusPress::Catalogue::AuthorsController < AureliusPress::ApplicationController
  def index
    @authors = Author.all
  end

  def show
    @author = Author.find(params[:id])
  end
end
