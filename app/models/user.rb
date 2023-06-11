class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :leitner_card_boxes, dependent: :destroy
  has_many :cards, dependent: :destroy

  after_create :create_leitner_card_boxes

  private

  def create_leitner_card_boxes
    LeitnerCardBox::DEFAULT_REPEAT_PERIODS.each do |repeat_period|
      leitner_card_boxes.create!(repeat_period: repeat_period)
    end
  end
end
