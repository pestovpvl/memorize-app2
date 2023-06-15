class CardsController < ApplicationController
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
    @cards = current_user.cards.joins(:leitner_card_box)
        .select { |card| card.last_reviewed_at.nil? || (Time.current - card.last_reviewed_at) >= card.leitner_card_box.repeat_period.days }
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
    redirect_to learn_cards_path
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
