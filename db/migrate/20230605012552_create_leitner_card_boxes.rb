class CreateLeitnerCardBoxes < ActiveRecord::Migration[7.0]
  def change
    create_table :leitner_card_boxes do |t|
      t.integer :repeat_period
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
