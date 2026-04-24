class AureliusPress::Community::LikesController < AureliusPress::ApplicationController
  before_action :set_like, only: [ :destroy ]

  def create
    @likeable = GlobalID::Locator.locate(params[:like][:likeable_gid])
    @like = AureliusPress::Community::Like.find_or_initialize_by(
      user: current_user,
      likeable: @likeable
    )
    authorize @like, :create?, policy_class: AureliusPress::Community::LikePolicy

    if @like.state == params[:like][:state]
      @like.state = :no_reaction
    else
      @like.state = params[:like][:state]
    end

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Reaction updated." }
        format.json { render json: @like, status: :ok }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
        format.html { redirect_back fallback_location: root_path, alert: @like.errors.full_messages.to_sentence }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @like, :destroy?, policy_class: AureliusPress::Community::LikePolicy
    @like.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path, notice: "Reaction removed." }
      format.json { head :no_content }
    end
  end

  private

  def set_like
    @like = AureliusPress::Community::Like.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:likeable_gid, :state)
  end
end
