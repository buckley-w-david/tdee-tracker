require "application_system_test_case"

class Fitness::ExcercisesTest < ApplicationSystemTestCase
  setup do
    @fitness_exercise = fitness_exercises(:one)
  end

  test "visiting the index" do
    visit fitness_exercises_url
    assert_selector "h1", text: "Excercises"
  end

  test "should create exercise" do
    visit fitness_exercises_url
    click_on "New exercise"

    click_on "Create Excercise"

    assert_text "Excercise was successfully created"
    click_on "Back"
  end

  test "should update Excercise" do
    visit fitness_exercise_url(@fitness_exercise)
    click_on "Edit this exercise", match: :first

    click_on "Update Excercise"

    assert_text "Excercise was successfully updated"
    click_on "Back"
  end

  test "should destroy Excercise" do
    visit fitness_exercise_url(@fitness_exercise)
    click_on "Destroy this exercise", match: :first

    assert_text "Excercise was successfully destroyed"
  end
end
