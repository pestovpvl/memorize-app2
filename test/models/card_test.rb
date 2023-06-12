require 'test_helper'

class CardTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: 'art@gmail.com', password: 'password', password_confirmation: 'password')

    @box1 = @user.leitner_card_boxes.find_by(repeat_period: 1)
    @box2 = @user.leitner_card_boxes.find_by(repeat_period: 3)
    @last_box = @user.leitner_card_boxes.find_by(repeat_period: 7)

    @card = Card.create!(word: 'test', definition: 'test', user: @user, leitner_card_box: @box1)
  end

  test 'should remember card' do
    @card.remember

    assert_equal @box2, @card.reload.leitner_card_box
  end

  test 'should forget card' do
    @card.leitner_card_box = @box2
    @card.save
    @card.forget

    assert_equal @box1, @card.reload.leitner_card_box
  end

  test 'should remove card in last box' do
    @card.leitner_card_box = @last_box
    @card.save
    @card.remember
  
    assert_raises(ActiveRecord::RecordNotFound) { @card.reload }
  end  
end
