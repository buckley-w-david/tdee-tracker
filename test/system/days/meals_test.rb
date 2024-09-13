require "application_system_test_case"

class Days::MealsTest < ApplicationSystemTestCase
  setup do
    @days_meal = days_meals(:one)
  end

  test "visiting the index" do
    visit days_meals_url
    assert_selector "h1", text: "Meals"
  end

  test "should create meal" do
    visit days_meals_url
    click_on "New meal"

    click_on "Create Meal"

    assert_text "Meal was successfully created"
    click_on "Back"
  end

  test "should update Meal" do
    visit days_meal_url(@days_meal)
    click_on "Edit this meal", match: :first

    click_on "Update Meal"

    assert_text "Meal was successfully updated"
    click_on "Back"
  end

  test "should destroy Meal" do
    visit days_meal_url(@days_meal)
    click_on "Destroy this meal", match: :first

    assert_text "Meal was successfully destroyed"
  end
end
