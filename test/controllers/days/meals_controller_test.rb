require "test_helper"

class Days::MealsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @days_meal = days_meals(:one)
  end

  test "should get index" do
    get days_meals_url
    assert_response :success
  end

  test "should get new" do
    get new_days_meal_url
    assert_response :success
  end

  test "should create days_meal" do
    assert_difference("Days::Meal.count") do
      post days_meals_url, params: { days_meal: {} }
    end

    assert_redirected_to days_meal_url(Days::Meal.last)
  end

  test "should show days_meal" do
    get days_meal_url(@days_meal)
    assert_response :success
  end

  test "should get edit" do
    get edit_days_meal_url(@days_meal)
    assert_response :success
  end

  test "should update days_meal" do
    patch days_meal_url(@days_meal), params: { days_meal: {} }
    assert_redirected_to days_meal_url(@days_meal)
  end

  test "should destroy days_meal" do
    assert_difference("Days::Meal.count", -1) do
      delete days_meal_url(@days_meal)
    end

    assert_redirected_to days_meals_url
  end
end
