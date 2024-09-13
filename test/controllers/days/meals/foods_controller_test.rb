require "test_helper"

class Days::Meals::FoodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @days_meals_food = days_meals_foods(:one)
  end

  test "should get index" do
    get days_meals_foods_url
    assert_response :success
  end

  test "should get new" do
    get new_days_meals_food_url
    assert_response :success
  end

  test "should create days_meals_food" do
    assert_difference("Days::Meals::Food.count") do
      post days_meals_foods_url, params: { days_meals_food: {} }
    end

    assert_redirected_to days_meals_food_url(Days::Meals::Food.last)
  end

  test "should show days_meals_food" do
    get days_meals_food_url(@days_meals_food)
    assert_response :success
  end

  test "should get edit" do
    get edit_days_meals_food_url(@days_meals_food)
    assert_response :success
  end

  test "should update days_meals_food" do
    patch days_meals_food_url(@days_meals_food), params: { days_meals_food: {} }
    assert_redirected_to days_meals_food_url(@days_meals_food)
  end

  test "should destroy days_meals_food" do
    assert_difference("Days::Meals::Food.count", -1) do
      delete days_meals_food_url(@days_meals_food)
    end

    assert_redirected_to days_meals_foods_url
  end
end
