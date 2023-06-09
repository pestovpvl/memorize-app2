require "test_helper"

class CardsControllerTest < ActionDispatch::IntegrationTest
  # Include Devise test helpers
  include Devise::Test::IntegrationHelpers
  setup do
    @card = cards(:one)

    @user = users(:one)
    @user2 = users(:two)

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
    get card_url(@card)
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
    @user2_card = Card.create!(word: "word", definition: "definition", leitner_card_box: @user2.leitner_card_boxes.first, user: @user2)

    get card_url(@user2_card)
    assert_redirected_to cards_url
  end
end
