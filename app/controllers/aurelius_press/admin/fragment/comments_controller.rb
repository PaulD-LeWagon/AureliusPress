class AureliusPress::Admin::Fragment::CommentsController < AureliusPress::Admin::ApplicationController
  before_action :set_comment, only: %i[ show destroy ] # edit update

  # GET /aurelius_press/admin/fragment/comments
  def index
    @comments = AureliusPress::Fragment::Comment.all
  end

  # GET /aurelius_press/admin/fragment/comments/1
  def show
    # @comment is set by before_action
  end

  # # GET /aurelius_press/admin/fragment/comments/new
  # def new
  #   @comment = AureliusPress::Fragment::Comment.new
  # end

  # # GET /aurelius_press/admin/fragment/comments/1/edit
  # def edit
  #   # @comment is set by before_action
  # end

  # # POST /aurelius_press/admin/fragment/comments
  # def create
  #   @comment = AureliusPress::Fragment::Comment.new(comment_params)

  #   if @comment.save
  #     redirect_to aurelius_press_admin_fragment_comment_path(@comment), notice: action_was_successfully(:created)
  #   else
  #     render :new, status: :unprocessable_entity # Uses the 'new' template with validation errors
  #   end
  # end

  # # PATCH/PUT /aurelius_press/admin/fragment/comments/1
  # def update
  #   if @comment.update(comment_params)
  #     redirect_to aurelius_press_admin_fragment_comment_path(@comment), notice: action_was_successfully(:updated)
  #   else
  #     render :edit, status: :unprocessable_entity # Uses the 'edit' template with validation errors
  #   end
  # end

  # DELETE /aurelius_press/admin/fragment/comments/1
  def destroy
    @comment.destroy! # Use destroy! for immediate errors if deletion fails
    redirect_to aurelius_press_admin_fragment_comments_url, notice: action_was_successfully(:deleted)
  end

  private

  def set_comment
    @comment = AureliusPress::Fragment::Comment.find(params[:id])
  end

  def action_was_successfully(action)
    "Comment #{action} successfully."
  end

  def comment_params
    params.require(:aurelius_press_fragment_comment).permit(
      :id,
      :user_id,
      :commentable_id,
      :commentable_type,
      :type,
      :status,
      :visibility,
      :content,
    )
  end
end
