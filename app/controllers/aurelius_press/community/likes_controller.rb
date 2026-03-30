class AureliusPress::Community::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @likeable = GlobalID::Locator.locate(params[:like][:likeable_gid])
    @like = AureliusPress::Community::Like.find_or_initialize_by(
      user: current_user,
      likeable: @likeable
    )

    # Toggle if same state, otherwise update
    if @like.state == params[:like][:state]
      @like.state = :no_reaction
    else
      @like.state = params[:like][:state]
    end

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path }
      end
    else
      head :unprocessable_entity
    end
  end

  # DELETE /likes/:id
  # Allows removing a vote completely (reset to neutral effectively, or delete record)
  def destroy
    @like = AureliusPress::Community::Like.find(params[:id])
    # Authorization check needed here
    @like.destroy
    head :no_content
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :likeable_type, :likeable_id, :state)
  end
end
