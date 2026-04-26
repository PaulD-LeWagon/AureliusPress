class AureliusPress::Catalogue::NotesController < AureliusPress::ApplicationController
  before_action :set_notable
  before_action :set_note, only: %i[update destroy]

  def create
    @note = @notable.notes.build(note_params.merge(user: current_user))
    authorize @note, :create?, policy_class: AureliusPress::Fragment::NotePolicy

    if @note.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Note added." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
        format.html { redirect_back fallback_location: root_path, alert: @note.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    authorize @note, :update?, policy_class: AureliusPress::Fragment::NotePolicy

    if @note.update(note_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Note updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
        format.html { redirect_back fallback_location: root_path, alert: @note.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    authorize @note, :destroy?, policy_class: AureliusPress::Fragment::NotePolicy
    @note.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path, notice: "Note removed." }
    end
  end

  private

  def set_notable
    @notable = if params[:author_slug]
      AureliusPress::Catalogue::Author.find_by!(slug: params[:author_slug])
    elsif params[:source_slug]
      AureliusPress::Catalogue::Source.find_by!(slug: params[:source_slug])
    elsif params[:quote_slug]
      AureliusPress::Catalogue::Quote.find_by!(slug: params[:quote_slug])
    end
  end

  def set_note
    @note = @notable.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
