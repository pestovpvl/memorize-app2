class ChangeCardsLeitnerCardBoxIdToAllowNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :cards, :leitner_card_box_id, true
  end
end
