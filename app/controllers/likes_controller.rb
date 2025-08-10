class LikesController < ApplicationController
  # Application logic in controllers/views:
  # First reaction: Create a new AureliusPress::Community::Like record with the chosen emoji.
  # Change reaction: Find the existing AureliusPress::Community::Like record and update its emoji attribute.
  # Remove reaction: Find the existing AureliusPress::Community::Like record and destroy it.
  # before_action :authenticate_user!

  def index
    @likes = Like.all
    render json: @likes
  end

  def create
    @like = Like.new(like_params)
    if @like.save
      render json: @like, status: :created
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    head :no_content
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :likeable_type, :likeable_id, :emoji)
  end
end
