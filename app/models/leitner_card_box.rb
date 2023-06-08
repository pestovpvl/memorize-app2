class LeitnerCardBox < ApplicationRecord
  belongs_to :user
  has_many :cards

  before_destroy :remove_associated_cards

  private

  def remove_associated_cards
    cards.update_all(leitner_card_box_id: nil)
  end
end
