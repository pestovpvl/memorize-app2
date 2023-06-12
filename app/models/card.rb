class Card < ApplicationRecord
  belongs_to :user
  belongs_to :leitner_card_box

  def remember
    next_box = leitner_card_box.next_box
    
    if next_box
      # Move to the next box
      self.update(
        leitner_card_box: next_box,
        updated_at: Time.now
      )
    else
      # No next box, remove the card
      self.destroy
    end
  end

  def forget
    # Move back to the first box
    self.update(
      leitner_card_box: LeitnerCardBox.first_box(user),
      updated_at: Time.now
    )
  end
end
