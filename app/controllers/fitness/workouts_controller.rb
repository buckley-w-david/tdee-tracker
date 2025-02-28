class Fitness::WorkoutsController < ApplicationController
  before_action :set_fitness_workout, only: %i[ show edit update destroy ]

  # GET /fitness/workouts or /fitness/workouts.json
  def index
    start_date = params[:start_date]&.to_date || Time.current
    @workouts = @current_user.workouts
      .includes(:workout_plan)
      .where(date: start_date.beginning_of_month..start_date.end_of_month).group_by(&:date)

    @plans = @current_user.workout_plans
      .where(planned_date: start_date.beginning_of_month..start_date.end_of_month).group_by(&:planned_date)
  end

  # GET /fitness/workouts/1 or /fitness/workouts/1.json
  def show
  end

  # GET /fitness/workouts/new
  def new
    workout_plan = @current_user.workout_plans
      .includes(workout_plan_exercises: [ :set_plans, :exercise ])
      .find(params.require(:workout_plan_id))

    @fitness_workout = Fitness::Workout.from_plan(workout_plan)
  end

  # GET /fitness/workouts/1/edit
  def edit
  end

  # POST /fitness/workouts or /fitness/workouts.json
  def create
    @fitness_workout = Fitness::Workout.new(user: @current_user, **fitness_workout_params)

    respond_to do |format|
      if @fitness_workout.save
        format.html { redirect_to @fitness_workout, notice: "Workout was successfully created." }
        format.json { render :show, status: :created, location: @fitness_workout }
      else
        format.html do
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @fitness_workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fitness/workouts/1 or /fitness/workouts/1.json
  def update
    respond_to do |format|
      if @fitness_workout.update(fitness_workout_params)
        format.html { redirect_to @fitness_workout, notice: "Workout was successfully updated." }
        format.json { render :show, status: :ok, location: @fitness_workout }
      else
        format.html do
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: @fitness_workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fitness/workouts/1 or /fitness/workouts/1.json
  def destroy
    @fitness_workout.destroy!

    respond_to do |format|
      format.html { redirect_to fitness_workouts_path, status: :see_other, notice: "Workout was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fitness_workout
      @fitness_workout = @current_user.workouts
        .includes(workout_exercises: [ :exercise, :sets ])
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fitness_workout_params
      params.require(:fitness_workout).permit(
        :date,
        :workout_plan_id,
        workout_exercises_attributes: [
          :id,
          :workout_id,
          :exercise_id,
          sets_attributes: [
            :id,
            :workout_exercise_id,
            :reps,
            :planned_reps,
            :weight,
            :planned_weight
          ]
        ]
    ).tap do |params|
      params[:workout_exercises_attributes].each do |_, workout_exercise|
        workout_exercise[:sets_attributes].each do |_, set|
          set[:reps] = nil if set[:reps].blank?
          set[:weight] = set[:planned_weight] if set[:weight].blank?
        end
      end
    end
  end
end
