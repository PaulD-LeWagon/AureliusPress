class AureliusPress::Admin::Catalogue::QuotesController < ApplicationController
  before_action :set_quote, only: %i[ show edit update destroy ]

  # GET /aurelius-press/admin/catalogue/quotes
  def index
    @quotes = AureliusPress::Catalogue::Quote.all
  end

  # GET /aurelius-press/admin/catalogue/quotes/:id
  def show
  end

  # GET /aurelius-press/admin/catalogue/quotes/new
  def new
    @quote = AureliusPress::Catalogue::Quote.new
  end

  # GET /aurelius-press/admin/catalogue/quotes/:id/edit
  def edit
  end

  # POST /aurelius-press/admin/catalogue/quotes
  def create
    @quote = AureliusPress::Catalogue::Quote.new(quote_params)

    if @quote.save
      redirect_to aurelius_press_admin_catalogue_quote_path(@quote), notice: "Quote was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aurelius-press/admin/catalogue/quotes/:id
  def update
    if @quote.update(quote_params)
      redirect_to aurelius_press_admin_catalogue_quote_path(@quote), notice: "Quote was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /aurelius-press/admin/catalogue/quotes/:id
  def destroy
    @quote.destroy!
    redirect_to aurelius_press_admin_catalogue_quotes_url, notice: "Quote was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_quote
    @quote = AureliusPress::Catalogue::Quote.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def quote_params
    params.require(:aurelius_press_catalogue_quote).permit(
      :id,
      :text,
      :source_id,
      :original_quote_id,
    )
  end
end
