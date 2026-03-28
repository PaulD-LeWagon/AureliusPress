class AureliusPress::Community::ReactionsController < ApplicationController
  # Application logic in controllers/views:
  # First reaction: Create a new AureliusPress::Community::Reaction record with the chosen emoji.
  # Change reaction: Find the existing AureliusPress::Community::Reaction record and update its emoji attribute.
  # Remove reaction: Find the existing AureliusPress::Community::Reaction record and destroy it.
  # before_action :authenticate_user!


  def create
    @reaction = AureliusPress::Community::Reaction.new(reaction_params)
    if @reaction.save
      render json: @reaction, status: :created
    else
      render json: @reaction.errors, status: :unprocessable_entity
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
