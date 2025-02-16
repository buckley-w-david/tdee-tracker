require "test_helper"

class Fitness::WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fitness_workout = fitness_workouts(:one)
  end

  test "should get index" do
    get fitness_workouts_url
    assert_response :success
  end

  test "should get new" do
    get new_fitness_workout_url
    assert_response :success
  end

  test "should create fitness_workout" do
    assert_difference("Fitness::Workout.count") do
      post fitness_workouts_url, params: { fitness_workout: {} }
    end

    assert_redirected_to fitness_workout_url(Fitness::Workout.last)
  end

  test "should show fitness_workout" do
    get fitness_workout_url(@fitness_workout)
    assert_response :success
  end

  test "should get edit" do
    get edit_fitness_workout_url(@fitness_workout)
    assert_response :success
  end

  test "should update fitness_workout" do
    patch fitness_workout_url(@fitness_workout), params: { fitness_workout: {} }
    assert_redirected_to fitness_workout_url(@fitness_workout)
  end

  test "should destroy fitness_workout" do
    assert_difference("Fitness::Workout.count", -1) do
      delete fitness_workout_url(@fitness_workout)
    end

    assert_redirected_to fitness_workouts_url
  end
end
