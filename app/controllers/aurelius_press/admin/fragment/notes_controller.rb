class AureliusPress::Admin::Fragment::NotesController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = AureliusPress::Fragment::Note.all
  end

  def show
    # @note is set by the before_action :set_note
  end

  def new
    @note = AureliusPress::Fragment::Note.new
  end

  def create
    @note = AureliusPress::Fragment::Note.new(note_params)
    if @note.save
      redirect_to aurelius_press_admin_fragment_note_path(@note), notice: "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @note is set by the before_action :set_note
  end

  def update
    if @note.update(note_params)
      redirect_to aurelius_press_admin_fragment_note_path(@note), notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    redirect_to aurelius_press_admin_fragment_notes_path, notice: "Note was successfully destroyed."
  end

  private

  def set_note
    @note = AureliusPress::Fragment::Note.find(params[:id])
    if @note.nil?
      redirect_to aurelius_press_admin_fragment_notes_path, alert: "Note not found."
    end
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
