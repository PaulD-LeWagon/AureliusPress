class AureliusPress::Catalogue::SourcesController < AureliusPress::ApplicationController
  def index
    @sources = AureliusPress::Catalogue::Source.all
  end

  def show
    if params[:slug].present?
      @source = AureliusPress::Catalogue::Source.find_by(slug: params[:slug])
    elsif params[:id].present?
      @source = AureliusPress::Catalogue::Source.find(params[:id])
    else
      raise ActiveRecord::RecordNotFound, "No identifier provided"
    end
  end
end
