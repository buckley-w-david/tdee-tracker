require "test_helper"

class Day::Meal::FoodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @day_meal_food = day_meal_foods(:one)
  end

  test "should get index" do
    get day_meal_foods_url
    assert_response :success
  end

  test "should get new" do
    get new_day_meal_food_url
    assert_response :success
  end

  test "should create day_meal_food" do
    assert_difference("Day::Meal::Food.count") do
      post day_meal_foods_url, params: { day_meal_food: {} }
    end

    assert_redirected_to day_meal_food_url(Day::Meal::Food.last)
  end

  test "should show day_meal_food" do
    get day_meal_food_url(@day_meal_food)
    assert_response :success
  end

  test "should get edit" do
    get edit_day_meal_food_url(@day_meal_food)
    assert_response :success
  end

  test "should update day_meal_food" do
    patch day_meal_food_url(@day_meal_food), params: { day_meal_food: {} }
    assert_redirected_to day_meal_food_url(@day_meal_food)
  end

  test "should destroy day_meal_food" do
    assert_difference("Day::Meal::Food.count", -1) do
      delete day_meal_food_url(@day_meal_food)
    end

    assert_redirected_to day_meal_foods_url
  end
end
