require 'csv'

class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card, only: %i[ show edit update destroy ]
  before_action :require_owner, only: %i[ show edit update destroy ]

  # GET /cards or /cards.json
  def index
    @cards = current_user.cards
  end

  # GET /cards/1 or /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards or /cards.json
  def create
    @card = Card.new(card_params)
    @card.user = current_user
    @card.leitner_card_box = LeitnerCardBox.where(repeat_period: LeitnerCardBox.minimum(:repeat_period)).first
    respond_to do |format|
      if @card.save
        format.html { redirect_to card_url(@card), notice: "Card was successfully created." }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1 or /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to card_url(@card), notice: "Card was successfully updated." }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1 or /cards/1.json
  def destroy
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url, notice: "Card was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def learn
    current_date = Time.current
    @cards = current_user.cards.joins(:leitner_card_box)
                 .where("cards.last_reviewed_at IS NULL OR (EXTRACT(EPOCH FROM (? - cards.last_reviewed_at))/86400)::integer >= leitner_card_boxes.repeat_period", current_date)
    @card = @cards.sample
  end
  
  
  def remember
    @card = current_user.cards.find(params[:id])
    @card.remember
    redirect_to learn_cards_path
  end
  
  def forget
    @card = current_user.cards.find(params[:id])
    @card.forget
    # flash[:alert] = "#{@card.word}: #{ @card.definition }"
    redirect_to learn_cards_path
  end

  def import
    file = params[:file]
    if file.nil?
      flash[:error] = "You must select a file first"
    else
      new_cards_count = 0
      updated_cards_count = 0
      error_count = 0
  
      begin
        ActiveRecord::Base.transaction do
          CSV.foreach(file.path, headers: true) do |row|
            card = Card.find_or_initialize_by(
              word: row[2].strip, 
              user: current_user, 
              leitner_card_box: current_user.leitner_card_boxes.find_by(repeat_period: 1)
            )
            card.definition = row[3]
            if card.new_record?
              new_cards_count += 1 if card.save
            else
              updated_cards_count += 1 if card.save
            end
          rescue => e
            error_count += 1 # increment error count
            Rails.logger.error "Failed to import card: #{e.message}"
            next
          end
        end
  
        flash[:notice] = "Successfully imported #{new_cards_count} new cards and updated #{updated_cards_count} existing cards. Failed to import #{error_count} cards."
      rescue StandardError => e
        flash[:error] = "Error importing cards: #{e.message}"
      end
    end
    redirect_back(fallback_location: cards_path)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def card_params
      params.require(:card).permit(:word, :definition, :leitner_card_box_id)
    end

    def require_owner
      unless current_user == @card.user
        redirect_to cards_url, notice: "You are not authorized to perform this action."
      end
    end
end
