class AureliusPress::Document::JournalEntriesController < AureliusPress::ApplicationController
  before_action :set_journal_entry, only: %i[show edit update destroy]

  def index
    authorize AureliusPress::Document::JournalEntry, :index?, policy_class: AureliusPress::DocumentPolicy
    @journal_entries = AureliusPress::Document::JournalEntry.where(user: current_user).recent
  end

  def show
    authorize @journal_entry, :show?, policy_class: AureliusPress::DocumentPolicy
  end

  def new
    @journal_entry = AureliusPress::Document::JournalEntry.new
    authorize @journal_entry, :new?, policy_class: AureliusPress::DocumentPolicy
  end

  def create
    @journal_entry = AureliusPress::Document::JournalEntry.new(journal_entry_params.merge(user: current_user, visibility: :private_to_owner))
    authorize @journal_entry, :create?, policy_class: AureliusPress::DocumentPolicy

    if @journal_entry.save
      redirect_to aurelius_press_journal_entry_path(@journal_entry), notice: "Journal entry created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @journal_entry, :edit?, policy_class: AureliusPress::DocumentPolicy
  end

  def update
    authorize @journal_entry, :update?, policy_class: AureliusPress::DocumentPolicy

    if @journal_entry.update(journal_entry_params)
      redirect_to aurelius_press_journal_entry_path(@journal_entry), notice: "Journal entry updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @journal_entry, :destroy?, policy_class: AureliusPress::DocumentPolicy
    @journal_entry.destroy
    redirect_to aurelius_press_journal_entries_path, notice: "Journal entry deleted."
  end

  private

  def set_journal_entry
    @journal_entry = AureliusPress::Document::JournalEntry.find_by!(slug: params[:id])
  end

  def journal_entry_params
    params.require(:aurelius_press_document_journal_entry).permit(
      :title,
      :subtitle,
      :description,
      :status,
      :comments_enabled,
      category_ids: [],
      content_blocks_attributes: [
        :id,
        :_destroy,
        :contentable_id,
        :contentable_type,
        :position,
        :html_id,
        :html_class,
        :data_attributes,
        contentable_attributes: [
          :id,
          :type,
          :content,
          :image,
          :caption,
          :alignment,
          :link_text,
          :link_title,
          :link_class,
          :link_target,
          :link_url,
          :embed_code,
          :description,
          :video_url,
          :layout_type,
          images: []
        ]
      ]
    )
  end
end
