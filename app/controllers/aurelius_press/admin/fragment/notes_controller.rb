class AureliusPress::Admin::Fragment::NotesController < AureliusPress::Admin::ApplicationController
  # before_action :authenticate_user!
  before_action :set_note, only: [:show, :destroy] # :edit, :update

  ## Admin interface for managing notes
  # This section contains actions for managing notes in the admin interface.
  # Only index, show, and destroy actions are currently enabled as that is all
  # that is needed for moderation purposes.
  #
  # Other actions (new, edit, create, update) are commented out to prevent
  # creation or modification of notes via the admin interface.
  # However, when soft deletion is implemented, the update action will be needed.
  # And a "Reporting" and "User Ban" feature will be required in the future.
  #
  # @todo: Implement soft deletion for notes
  # @todo Add pagination to index action if notes volume is high.

  def index
    @notes = AureliusPress::Fragment::Note.all
  end

  def show
    # @note is set by the before_action :set_note
  end

  # def new
  #   @note = AureliusPress::Fragment::Note.new
  # end

  # def create
  #   @note = AureliusPress::Fragment::Note.new(note_params)
  #   if @note.save
  #     redirect_to aurelius_press_admin_fragment_note_path(@note), notice: action_was_successfully(:created)
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  # def edit
  #   # @note is set by the before_action :set_note
  # end

  # def update
  #   if @note.update(note_params)
  #     redirect_to aurelius_press_admin_fragment_note_path(@note), notice: action_was_successfully(:updated)
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  def destroy
    @note.destroy
    redirect_to aurelius_press_admin_fragment_notes_path, notice: action_was_successfully(:deleted)
  end

  private

  def set_note
    @note = AureliusPress::Fragment::Note.find(params[:id])
    if @note.nil?
      redirect_to aurelius_press_admin_fragment_notes_path, alert: "Note not found."
    end
  end

  def action_was_successfully(action)
    "Note #{action} successfully."
  end

  def note_params
    params.require(:aurelius_press_fragment_note).permit(
      :user_id,
      :notable_id,
      :notable_type,
      :type,
      :title,
      :content,
      :status,
      :visibility,
      :position
    )
  end
end
