class AddLastReviewedAtToCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :last_reviewed_at, :datetime
  end
end
