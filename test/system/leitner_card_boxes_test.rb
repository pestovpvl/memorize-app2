require "application_system_test_case"

class LeitnerCardBoxesTest < ApplicationSystemTestCase
  setup do
    @leitner_card_box = leitner_card_boxes(:one)
  end

  test "visiting the index" do
    visit leitner_card_boxes_url
    assert_selector "h1", text: "Leitner card boxes"
  end

  test "should create leitner card box" do
    visit leitner_card_boxes_url
    click_on "New leitner card box"

    fill_in "Repeat period", with: @leitner_card_box.repeat_period
    fill_in "User", with: @leitner_card_box.user_id
    click_on "Create Leitner card box"

    assert_text "Leitner card box was successfully created"
    click_on "Back"
  end

  test "should update Leitner card box" do
    visit leitner_card_box_url(@leitner_card_box)
    click_on "Edit this leitner card box", match: :first

    fill_in "Repeat period", with: @leitner_card_box.repeat_period
    fill_in "User", with: @leitner_card_box.user_id
    click_on "Update Leitner card box"

    assert_text "Leitner card box was successfully updated"
    click_on "Back"
  end

  test "should destroy Leitner card box" do
    visit leitner_card_box_url(@leitner_card_box)
    click_on "Destroy this leitner card box", match: :first

    assert_text "Leitner card box was successfully destroyed"
  end
end
