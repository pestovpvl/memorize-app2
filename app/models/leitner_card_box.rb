class LeitnerCardBox < ApplicationRecord
  belongs_to :user
  has_many :cards

  validates :repeat_period, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :user_id }

  # default repeat periods for new users
  DEFAULT_REPEAT_PERIODS = [1, 3, 7].freeze
  
  before_destroy :remove_associated_cards

  def next_box
    # You might want to limit the number of boxes.
    # Here it's assumed that the box with the higher repeat_period is the next box.
    user.leitner_card_boxes.where('repeat_period > ?', self.repeat_period).order(:repeat_period).first
  end

  # Class method to get the first box.
  def self.first_box(user)
    user.leitner_card_boxes.order(:repeat_period).first
  end

  private

  def remove_associated_cards
    cards.update_all(leitner_card_box_id: nil)
  end
end
