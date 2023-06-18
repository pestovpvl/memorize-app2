require "test_helper"

class LeitnerCardBoxesControllerTest < ActionDispatch::IntegrationTest
  # Include Devise test helpers
  include Devise::Test::IntegrationHelpers
  setup do
    @leitner_card_box = leitner_card_boxes(:box1)
    @user = User.create!(email: 'user1@gmail.com', password: 'password', password_confirmation: 'password')
    @user2 = User.create!(email: 'user2@gmail.com', password: 'password', password_confirmation: 'password')
    sign_in @user
  end

  test "should get index" do
    get leitner_card_boxes_url
    assert_response :success

    assert_not @response.body.include?(@user2.leitner_card_boxes.first.id.to_s)
  end

  test "should get new" do
    get new_leitner_card_box_url
    assert_response :success
  end

  test "should create leitner_card_box" do
    @leitner_card_box.repeat_period = 10
    assert_difference("LeitnerCardBox.count") do
      post leitner_card_boxes_url, params: { leitner_card_box: { repeat_period: @leitner_card_box.repeat_period, user_id: @leitner_card_box.user_id } }
    end

    assert_redirected_to leitner_card_boxes_url
  end

  test "should show leitner_card_box" do
    get leitner_card_box_url(@user.leitner_card_boxes.first)
    assert_response :success
  end

  test "should get edit" do
    get edit_leitner_card_box_url(@user.leitner_card_boxes.first)
    assert_response :success
  end

  test "should update leitner_card_box" do
    leitner_card_box = LeitnerCardBox.create!(repeat_period: 10, user: @user)
    
    patch leitner_card_box_url(leitner_card_box), params: { leitner_card_box: { repeat_period: leitner_card_box.repeat_period, user_id: leitner_card_box.user_id } }
    assert_redirected_to leitner_card_box_url(leitner_card_box)
  end

  test "should destroy leitner_card_box" do
    leitner_card_box_to_delete = LeitnerCardBox.create!(repeat_period: 10, user: @user)
    assert_difference("LeitnerCardBox.count", -1) do
      delete leitner_card_box_url(leitner_card_box_to_delete)
    end
  
    assert_redirected_to leitner_card_boxes_url
  end

  test "should create three leitner card boxes if user has none" do
    new_user = User.create!(email: 'new_user@example.com', password: 'password', password_confirmation: 'password')

    assert_equal 3, new_user.leitner_card_boxes.count

    expected_repeat_periods = [1, 3, 7]
    new_user.leitner_card_boxes.each do |box|
      assert expected_repeat_periods.include?(box.repeat_period)
    end
  end

  test "should not show leitner card box from other user" do
    # Create a Leitner card box for the second user
    @user2_leitner_card_box = LeitnerCardBox.create!(repeat_period: 10, user: @user2)
    
    # Try to show this box
    get leitner_card_box_url(@user2_leitner_card_box)
    
    # Check if the response is a redirect (to the sign_in page, for instance)
    assert_response :redirect
    
    # Or if you handle this case with an error, check if the response is an error
    # assert_response :forbidden
  end

  test "should have unique repeat_period per user" do
    
  end
end
