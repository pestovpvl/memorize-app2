class Card < ApplicationRecord
  belongs_to :user
  belongs_to :leitner_card_box
end
