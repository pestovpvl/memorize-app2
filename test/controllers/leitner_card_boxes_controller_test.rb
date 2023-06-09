require "test_helper"

class LeitnerCardBoxesControllerTest < ActionDispatch::IntegrationTest
  # Include Devise test helpers
  include Devise::Test::IntegrationHelpers
  setup do
    @leitner_card_box = leitner_card_boxes(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get leitner_card_boxes_url
    assert_response :success
  end

  test "should get new" do
    get new_leitner_card_box_url
    assert_response :success
  end

  test "should create leitner_card_box" do
    assert_difference("LeitnerCardBox.count") do
      post leitner_card_boxes_url, params: { leitner_card_box: { repeat_period: @leitner_card_box.repeat_period, user_id: @leitner_card_box.user_id } }
    end

    assert_redirected_to leitner_card_box_url(LeitnerCardBox.last)
  end

  test "should show leitner_card_box" do
    get leitner_card_box_url(@leitner_card_box)
    assert_response :success
  end

  test "should get edit" do
    get edit_leitner_card_box_url(@leitner_card_box)
    assert_response :success
  end

  test "should update leitner_card_box" do
    patch leitner_card_box_url(@leitner_card_box), params: { leitner_card_box: { repeat_period: @leitner_card_box.repeat_period, user_id: @leitner_card_box.user_id } }
    assert_redirected_to leitner_card_box_url(@leitner_card_box)
  end

  test "should destroy leitner_card_box" do
    assert_difference("LeitnerCardBox.count", -1) do
      delete leitner_card_box_url(@leitner_card_box)
    end

    assert_redirected_to leitner_card_boxes_url
  end

  test "should create three leitner card boxes if user has none" do
    @user.leitner_card_boxes.destroy_all

    get leitner_card_boxes_url
    assert_response :success

    assert_equal 3, @user.leitner_card_boxes.count

    expected_periods = [1, 3, 7]
    @user.leitner_card_boxes.each do |leitner_card_box|
      assert expected_periods.include?(leitner_card_box.repeat_period)
    end
  end

  test "should not create three leitner card boxes if user has one" do
    get leitner_card_boxes_url
    assert_response :success

    assert_equal 1, @user.leitner_card_boxes.count
  end
end
