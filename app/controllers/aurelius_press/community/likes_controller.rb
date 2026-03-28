class AureliusPress::Community::LikesController < ApplicationController
  # Public controller for genuine Likes (Votes)
  # before_action :authenticate_user! # Assuming there's authentication

  # POST /likes
  def create
    @like = AureliusPress::Community::Like.find_or_initialize_by(
      user_id: like_params[:user_id], # In real app, use current_user.id
      likeable_type: like_params[:likeable_type],
      likeable_id: like_params[:likeable_id]
    )

    # Update the state (toggle or set)
    # If the user sends the same state, maybe they want to toggle it off (to neutral)?
    # Or strict setting. Let's assume strict setting from UI for now.

    @like.state = like_params[:state]

    if @like.save
      render json: @like, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
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
