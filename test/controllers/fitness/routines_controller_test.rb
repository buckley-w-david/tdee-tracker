require "test_helper"

class Fitness::RoutinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fitness_routine = fitness_routines(:one)
  end

  test "should get index" do
    get fitness_routines_url
    assert_response :success
  end

  test "should get new" do
    get new_fitness_routine_url
    assert_response :success
  end

  test "should create fitness_routine" do
    assert_difference("Fitness::Routine.count") do
      post fitness_routines_url, params: { fitness_routine: {} }
    end

    assert_redirected_to fitness_routine_url(Fitness::Routine.last)
  end

  test "should show fitness_routine" do
    get fitness_routine_url(@fitness_routine)
    assert_response :success
  end

  test "should get edit" do
    get edit_fitness_routine_url(@fitness_routine)
    assert_response :success
  end

  test "should update fitness_routine" do
    patch fitness_routine_url(@fitness_routine), params: { fitness_routine: {} }
    assert_redirected_to fitness_routine_url(@fitness_routine)
  end

  test "should destroy fitness_routine" do
    assert_difference("Fitness::Routine.count", -1) do
      delete fitness_routine_url(@fitness_routine)
    end

    assert_redirected_to fitness_routines_url
  end
end
