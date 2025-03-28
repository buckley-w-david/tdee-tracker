require "application_system_test_case"

class Fitness::WorkoutsTest < ApplicationSystemTestCase
  setup do
    @fitness_workout = fitness_workouts(:one)
  end

  test "visiting the index" do
    visit fitness_workouts_url
    assert_selector "h1", text: "Workouts"
  end

  test "should create workout" do
    visit fitness_workouts_url
    click_on "New workout"

    click_on "Create Workout"

    assert_text "Workout was successfully created"
    click_on "Back"
  end

  test "should update Workout" do
    visit fitness_workout_url(@fitness_workout)
    click_on "Edit this workout", match: :first

    click_on "Update Workout"

    assert_text "Workout was successfully updated"
    click_on "Back"
  end

  test "should destroy Workout" do
    visit fitness_workout_url(@fitness_workout)
    click_on "Destroy this workout", match: :first

    assert_text "Workout was successfully destroyed"
  end
end
