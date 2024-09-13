class GoalsController < ApplicationController
  def index
    @goal = @current_user.goal || @current_user.build_goal
  end

  def create
    @goal = @current_user.build_goal(goal_params)

    if @goal.save
      redirect_to goals_path, success: "Goal was successfully created."
    else
      render :index
    end
  end

  def update
    @goal = @current_user.goal
    if @goal.update(goal_params)
      redirect_to goals_path, success: "Goal was successfully updated."
    else
      render :index
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:change_per_week)
  end
end
