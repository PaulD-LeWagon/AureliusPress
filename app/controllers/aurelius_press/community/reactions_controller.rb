class AureliusPress::Community::ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @reactable = GlobalID::Locator.locate(params[:reaction][:reactable_gid])
    @reaction = AureliusPress::Community::Reaction.find_or_initialize_by(
      user: current_user,
      reactable: @reactable
    )

    # Toggle if same emoji, otherwise update
    if @reaction.emoji == params[:reaction][:emoji]
      @reaction.emoji = :no_reaction
    else
      @reaction.emoji = params[:reaction][:emoji]
    end

    if @reaction.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @reaction = AureliusPress::Community::Reaction.find(params[:id])
    @reaction.destroy
    head :no_content
  end

  private

  def reaction_params
    params.require(:reaction).permit(:user_id, :reactable_type, :reactable_id, :emoji)
  end
end
