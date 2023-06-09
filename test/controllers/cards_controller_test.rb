require "test_helper"
require 'pry'

class CardsControllerTest < ActionDispatch::IntegrationTest
  # Include Devise test helpers
  include Devise::Test::IntegrationHelpers
  setup do
    

    @user = User.create!(email: 'user1@gmail.com', password: 'password', password_confirmation: 'password')
    @user2 = User.create!(email: 'user2@gmail.com', password: 'password', password_confirmation: 'password')
    @leitner_box = @user.leitner_card_boxes.first
    @card = Card.create!(word: "word", definition: "definition", leitner_card_box: @leitner_box, user: @user)

    sign_in @user
  end

  test "should get index" do
    @user2_cards = Card.create!(word: "word", definition: "definition", leitner_card_box: @user2.leitner_card_boxes.first, user: @user2)

    get cards_url
    assert_response :success

    assert_not @response.body.include?(@user2_cards.id.to_s)
  end

  test "should get new" do
    get new_card_url
    assert_response :success
  end

  test "should create card" do
    assert_difference("Card.count") do
      post cards_url, params: { card: { definition: @card.definition, leitner_card_box_id: @card.leitner_card_box_id, word: @card.word } }
    end

    assert_redirected_to card_url(Card.last)
  end

  test "should show card" do
    get card_url(@user.cards.first)
    assert_response :success
  end

  test "should get edit" do
    get edit_card_url(@card)
    assert_response :success
  end

  test "should update card" do
    patch card_url(@card), params: { card: { definition: @card.definition, leitner_card_box_id: @card.leitner_card_box_id, word: @card.word } }
    assert_redirected_to card_url(@card)
  end

  test "should destroy card" do
    assert_difference("Card.count", -1) do
      delete card_url(@card)
    end

    assert_redirected_to cards_url
  end

  test "should not show card box from another user" do
    new_user = User.create!(email: 'new_user@example.com', password: 'password', password_confirmation: 'password')
    @user2_card = Card.create!(word: "word", definition: "definition", leitner_card_box: new_user.leitner_card_boxes.first, user: new_user)

    get card_url(@user2_card)
    assert_redirected_to cards_url
  end

  test "learn should get learn" do
    get learn_cards_url
    assert_response :success
  end

  test 'should return card that was reviewed exactly one day ago' do
    @card.update(last_reviewed_at: (1.day.ago - 10.seconds))

    get learn_cards_url
    assert_response :success

    assert_includes @response.body, @card.id.to_s
  end

  test 'should not return card that was just reviewed' do
    @card.update(last_reviewed_at: Time.current)

    get learn_cards_url
    assert_response :success

    assert_not_includes @response.body, @card.id.to_s
  end

  test 'should return card that was never reviewed' do
    @card.update(last_reviewed_at: nil)

    get learn_cards_url
    assert_response :success

    assert_includes @response.body, @card.id.to_s
  end

  test 'should not return card that is not due for review yet' do
    @card.update(last_reviewed_at: Time.now)
    @card.leitner_card_box.update(repeat_period: 3)

    get learn_cards_url
    assert_response :success

    assert_not_includes @response.body, @card.id.to_s
  end
end
