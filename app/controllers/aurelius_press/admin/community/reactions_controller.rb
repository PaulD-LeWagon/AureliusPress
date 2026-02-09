class AureliusPress::Admin::Community::ReactionsController < AureliusPress::Admin::ApplicationController
  before_action :set_reaction, only: %i[ show edit update destroy ]

  # GET /aurelius_press/admin/community/reactions
  def index
    @reactions = AureliusPress::Community::Reaction.all
  end

  # GET /aurelius_press/admin/community/reactions/1
  def show
    # @reaction is set by before_action
  end

  # GET /aurelius_press/admin/community/reactions/new
  def new
    @reaction = AureliusPress::Community::Reaction.new
  end

  # GET /aurelius_press/admin/community/reactions/1/edit
  def edit
    # @reaction is set by before_action
  end

  # POST /aurelius_press/admin/community/reactions
  def create
    @reaction = AureliusPress::Community::Reaction.new(reaction_params)

    if @reaction.save
      redirect_to aurelius_press_admin_community_reaction_path(@reaction), notice: "Reaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aurelius_press/admin/community/reactions/1
  def update
    if @reaction.update(reaction_params)
      redirect_to aurelius_press_admin_community_reaction_path(@reaction), notice: "Reaction was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /aurelius_press/admin/community/reactions/1
  def destroy
    @reaction.destroy!
    redirect_to aurelius_press_admin_community_reactions_url, notice: "Reaction was successfully destroyed."
  end

  private

  def set_reaction
    @reaction = AureliusPress::Community::Reaction.find(params[:id])
  end

  def reaction_params
    params.require(:aurelius_press_community_reaction).permit(
      :id,
      :user_id,
      :reactable_id,
      :reactable_type,
      :emoji
    )
  end
end
