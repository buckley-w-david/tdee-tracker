class Fitness::RoutinesController < ApplicationController
  before_action :set_fitness_routine, only: %i[ show edit update destroy ]
  before_action :set_available_exercises, only: %i[ new edit ]

  # GET /fitness/routines or /fitness/routines.json
  def index
    @fitness_routines = Fitness::Routine
      .includes(workout_plans: { workout_plan_exercises: [ :exercise, :set_plans ] })
      .all
  end

  # GET /fitness/routines/1 or /fitness/routines/1.json
  def show
  end

  # GET /fitness/routines/new
  def new
    @fitness_routine = Fitness::Routine.new
  end

  # GET /fitness/routines/1/edit
  def edit
  end

  # POST /fitness/routines or /fitness/routines.json
  def create
    @fitness_routine = Fitness::Routine.new(user: @current_user, **fitness_routine_params)

    respond_to do |format|
      if @fitness_routine.save
        format.html { redirect_to @fitness_routine, notice: "Routine was successfully created." }
        format.json { render :show, status: :created, location: @fitness_routine }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fitness_routine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fitness/routines/1 or /fitness/routines/1.json
  def update
    respond_to do |format|
      if @fitness_routine.update(fitness_routine_params)
        format.html { redirect_to @fitness_routine, notice: "Routine was successfully updated." }
        format.json { render :show, status: :ok, location: @fitness_routine }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fitness_routine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fitness/routines/1 or /fitness/routines/1.json
  def destroy
    @fitness_routine.destroy!

    respond_to do |format|
      format.html { redirect_to fitness_routines_path, status: :see_other, notice: "Routine was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_available_exercises
    @available_exercises = Fitness::Exercise.all
  end

  def set_fitness_routine
    @fitness_routine = @current_user.routines
      .includes(workout_plans: { workout_plan_exercises: [ :exercise, :set_plans ] })
      .find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def fitness_routine_params
    params.require(:fitness_routine).permit(
      :name,
      schedule: [],
      workout_plans_attributes: [
        :id,
        :routine_id,
        :name,
        workout_plan_exercises_attributes: [
          :id,
          :workout_plan_id,
          :exercise_id,
          :weight_progression,
          :reps_progression,
          set_plans_attributes: [
            :_destroy,
            :id,
            :workout_plan_exercise_id,
            :reps,
            :weight
          ]
        ]
      ],
    )
  end
end
