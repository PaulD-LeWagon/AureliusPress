class AureliusPress::Catalogue::CommentsController < AureliusPress::ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[update destroy]

  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    authorize @comment, :create?, policy_class: AureliusPress::Fragment::CommentPolicy

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Comment added." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
        format.html { redirect_back fallback_location: root_path, alert: @comment.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    authorize @comment, :update?, policy_class: AureliusPress::Fragment::CommentPolicy

    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Comment updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
        format.html { redirect_back fallback_location: root_path, alert: @comment.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    authorize @comment, :destroy?, policy_class: AureliusPress::Fragment::CommentPolicy
    @comment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path, notice: "Comment removed." }
    end
  end

  private

  def set_commentable
    @commentable = if params[:author_slug]
      AureliusPress::Catalogue::Author.find_by!(slug: params[:author_slug])
    elsif params[:source_slug]
      AureliusPress::Catalogue::Source.find_by!(slug: params[:source_slug])
    elsif params[:quote_slug]
      AureliusPress::Catalogue::Quote.find_by!(slug: params[:quote_slug])
    elsif params[:note_id]
      AureliusPress::Fragment::Note.find(params[:note_id])
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
