class LeitnerCardBoxesController < ApplicationController
  before_action :set_leitner_card_box, only: %i[ show edit update destroy ]
  before_action :require_owner, only: %i[ show edit update destroy ]
  before_action :move_card_to_prev_box, only: %i[ destroy ]

  # GET /leitner_card_boxes or /leitner_card_boxes.json
  def index
    @leitner_card_boxes = current_user.leitner_card_boxes
  end

  # GET /leitner_card_boxes/1 or /leitner_card_boxes/1.json
  def show
  end

  # GET /leitner_card_boxes/new
  def new
    @leitner_card_box = LeitnerCardBox.new
  end

  # GET /leitner_card_boxes/1/edit
  def edit
  end

  # POST /leitner_card_boxes or /leitner_card_boxes.json
  def create
    @leitner_card_box = LeitnerCardBox.new(leitner_card_box_params)
    @leitner_card_box.user = current_user

    respond_to do |format|
      if @leitner_card_box.save
        format.html { redirect_to leitner_card_boxes_path, notice: "Leitner card box was successfully created." }
        format.json { render :show, status: :created, location: @leitner_card_box }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @leitner_card_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leitner_card_boxes/1 or /leitner_card_boxes/1.json
  def update
    respond_to do |format|
      if @leitner_card_box.update(leitner_card_box_params)
        format.html { redirect_to leitner_card_box_url(@leitner_card_box), notice: "Leitner card box was successfully updated." }
        format.json { render :show, status: :ok, location: @leitner_card_box }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @leitner_card_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leitner_card_boxes/1 or /leitner_card_boxes/1.json
  def destroy
    @leitner_card_box.destroy

    respond_to do |format|
      format.html { redirect_to leitner_card_boxes_url, notice: "Leitner card box was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leitner_card_box
      @leitner_card_box = LeitnerCardBox.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def leitner_card_box_params
      params.require(:leitner_card_box).permit(:repeat_period, :user_id)
    end

    def require_owner
      unless current_user == @leitner_card_box.user
        redirect_to leitner_card_boxes_url, notice: "You are not authorized to do that."
      end
    end

    def move_card_to_prev_box
      # Move cards to the prev box before destroying the box.
      # This is done to prevent orphan cards.
      @leitner_card_box.cards.update_all(leitner_card_box_id: LeitnerCardBox.prev_box(current_user, @leitner_card_box).id)
    end
end
