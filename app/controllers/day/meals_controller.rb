class Day
  class MealsController < ApplicationController
    before_action :set_day
    before_action :set_meal, only: %i[ edit update destroy ]
    before_action :backfill_foods!, only: %i[ create update ]

    # GET /days/:day_id/meals or /days/:day_id/meals.json
    def index
      @meals = @day.meals

      respond_to do |format|
        format.html
        format.json { render json: @meals }
      end
    end

    def copy
      @pagy, @meals = pagy(
        @current_user
          .meals
          .select("meals.*, days.date as day_date")
          .joins(:day)
          .order("days.date DESC")
      )
    end

    # GET /days/:day_id/meals/new
    def new
      source = @current_user.meals.find(params[:source_id]) if params[:source_id].present?
      @meal = @day.meals.build

      if source
        @meal.name = source.name
        @meal.food_entries = source.food_entries.map do |food_entry|
          food_entry.dup.tap { |fe| fe.id = nil }
        end
      end
    end

    # GET /days/:day_id/meals/1/edit
    def edit
    end

    # POST /days/:day_id/meals or /days/:day_id/meals.json
    def create
      @meal = @day.meals.build(meal_param)

      respond_to do |format|
        if @meal.save
          format.html { redirect_to edit_day_meal_url(@day, @meal), notice: "Meal was successfully created." }
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
          format.html { redirect_to day_meals_url(@day), notice: "Meal was successfully updated." }
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

    def backfill_foods!
      meal_param[:food_entries_attributes]&.each_value do |food_entry|
        if food_entry[:food_id].blank?
          food = Food.create!(
            name: food_entry[:food_name],
            kilocalories: food_entry[:food_kilocalories],
            unit: food_entry[:food_unit],
            quantity: food_entry[:food_quantity]
          )

          food_entry[:food_id] = food.id
        end
      end

      meal_param[:food_entries_attributes]&.transform_values! do |food_entry|
        food_entry.slice(:id, :food_id, :quantity, :unit, :_destroy)
      end
    end

    def set_day
      @day = Day.find(params[:day_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = @day
        .meals
        .includes(food_entries: :food)
        .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meal_param
      @meal_params ||= begin
        meal = params.permit(
          meal: [
            :name,
            food_entries_attributes: [
              :id,
              :food_id,
              :quantity,
              :unit,

              # If the user has selected a dynamic food that we haven't stored in the DB yet, we'll need to create it
              :food_name,
              :food_kilocalories,
              :food_quantity,
              :food_unit,

              :_destroy
            ]
          ]
        ).require(:meal)

        meal[:food_entries_attributes]&.reject! { |_, food| food[:food_name].blank? || food[:quantity].blank? }

        meal
      end
    end
  end
end
