require "test_helper"

class Fitness::ExcercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fitness_exercise = fitness_exercises(:one)
  end

  test "should get index" do
    get fitness_exercises_url
    assert_response :success
  end

  test "should get new" do
    get new_fitness_exercise_url
    assert_response :success
  end

  test "should create fitness_exercise" do
    assert_difference("Fitness::Excercise.count") do
      post fitness_exercises_url, params: { fitness_exercise: {} }
    end

    assert_redirected_to fitness_exercise_url(Fitness::Excercise.last)
  end

  test "should show fitness_exercise" do
    get fitness_exercise_url(@fitness_exercise)
    assert_response :success
  end

  test "should get edit" do
    get edit_fitness_exercise_url(@fitness_exercise)
    assert_response :success
  end

  test "should update fitness_exercise" do
    patch fitness_exercise_url(@fitness_exercise), params: { fitness_exercise: {} }
    assert_redirected_to fitness_exercise_url(@fitness_exercise)
  end

  test "should destroy fitness_exercise" do
    assert_difference("Fitness::Excercise.count", -1) do
      delete fitness_exercise_url(@fitness_exercise)
    end

    assert_redirected_to fitness_exercises_url
  end
end
