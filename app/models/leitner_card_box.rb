class LeitnerCardBox < ApplicationRecord
  belongs_to :user
  has_many :cards

  validates :repeat_period, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :user_id }

  # default repeat periods for new users
  DEFAULT_REPEAT_PERIODS = [1, 3, 7].freeze
  
  before_destroy :remove_associated_cards

  private

  def remove_associated_cards
    cards.update_all(leitner_card_box_id: nil)
  end
end
