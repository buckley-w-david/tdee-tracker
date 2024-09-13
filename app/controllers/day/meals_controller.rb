class Day
  class MealsController < ApplicationController
    before_action :set_day
    before_action :set_meal, only: %i[ show edit update destroy ]

    # GET /days/:day_id/meals or /days/:day_id/meals.json
    def index
      @meals = @day.meals
    end

    # GET /days/:day_id/meals/1 or /days/:day_id/meals/1.json
    def show
    end

    # GET /days/:day_id/meals/new
    def new
      @meal = @day.meals.build
    end

    # GET /days/:day_id/meals/1/edit
    def edit
    end

    # POST /days/:day_id/meals or /days/:day_id/meals.json
    def create
      @meal = @day.meals.build(meal_param)

      respond_to do |format|
        if @meal.save
          format.html { redirect_to day_meal_url(@day, @meal), notice: "Meal was successfully created." }
          format.json { render :show, status: :created, location: @meal }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @meal.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /days/:day_id/meals/1 or /days/:day_id/meals/1.json
    def update
      respond_to do |format|
        if @meal.update(meal_param)
          format.html { redirect_to day_meal_url(@day, @meal), notice: "Meal was successfully updated." }
          format.json { render :show, status: :ok, location: @meal }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @meal.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /days/:day_id/meals/1 or /days/:day_id/meals/1.json
    def destroy
      @meal.destroy!

      respond_to do |format|
        format.html { redirect_to day_meals_url(@day), notice: "Meal was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    def set_day
      @day = Day.find(params[:day_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = @day.meals.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meal_param
      params.fetch(:meal, {})
    end
  end
end
