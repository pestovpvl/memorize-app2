class LeitnerCardBoxesController < ApplicationController
  before_action :set_leitner_card_box, only: %i[ show edit update destroy ]

  # GET /leitner_card_boxes or /leitner_card_boxes.json
  def index
    @leitner_card_boxes = LeitnerCardBox.all
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

    respond_to do |format|
      if @leitner_card_box.save
        format.html { redirect_to leitner_card_box_url(@leitner_card_box), notice: "Leitner card box was successfully created." }
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
end
