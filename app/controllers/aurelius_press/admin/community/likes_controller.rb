class AureliusPress::Admin::Community::LikesController < ApplicationController
  before_action :set_like, only: %i[ show edit update destroy ]

  # GET /aurelius_press/admin/community/likes
  def index
    @likes = AureliusPress::Community::Like.all
  end

  # GET /aurelius_press/admin/community/likes/1
  def show
    # @like is set by before_action
  end

  # GET /aurelius_press/admin/community/likes/new
  def new
    @like = AureliusPress::Community::Like.new
  end

  # GET /aurelius_press/admin/community/likes/1/edit
  def edit
    # @like is set by before_action
  end

  # POST /aurelius_press/admin/community/likes
  def create
    @like = AureliusPress::Community::Like.new(like_params)

    if @like.save
      redirect_to aurelius_press_admin_community_like_path(@like), notice: "Like was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aurelius_press/admin/community/likes/1
  def update
    if @like.update(like_params)
      redirect_to aurelius_press_admin_community_like_path(@like), notice: "Like was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /aurelius_press/admin/community/likes/1
  def destroy
    @like.destroy!
    redirect_to aurelius_press_admin_community_likes_url, notice: "Like was successfully destroyed."
  end

  private

  def set_like
    @like = AureliusPress::Community::Like.find(params[:id])
  end

  def like_params
    params.require(:aurelius_press_community_like).permit(
      :id,
      :user_id,
      :likeable_id,
      :likeable_type,
      :emoji
    )
  end
end
