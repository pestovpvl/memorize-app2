class Card < ApplicationRecord
  belongs_to :user
  belongs_to :leitner_card_box

  def remember
    next_box = leitner_card_box.next_box
    
    if next_box
      # Move to the next box
      self.update(
        leitner_card_box: next_box,
        last_reviewed_at: Time.current
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
      last_reviewed_at: Time.current
    )
  end
end
