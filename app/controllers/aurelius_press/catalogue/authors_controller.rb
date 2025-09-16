class AureliusPress::Catalogue::AuthorsController < AureliusPress::ApplicationController
  def index
    @authors = AureliusPress::Catalogue::Author.all
  end

  def show
    if params[:slug].present?
      @author = AureliusPress::Catalogue::Author.find_by(slug: params[:slug])
    elsif params[:id].present?
      @author = AureliusPress::Catalogue::Author.find(params[:id])
    else
      raise ActiveRecord::RecordNotFound, "No identifier provided"
    end
  end
end
