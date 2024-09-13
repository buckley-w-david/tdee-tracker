class Days
  class Meals
    class FoodsController < ApplicationController
      before_action :set_day, :set_meal
      before_action :set_food, only: %i[ show edit update destroy ]

      # GET days/:day_id/meals/:meal_id/foods or days/:day_id/meals/:meal_id/foods.json
      def index
        @foods = @meal.foods
      end

      # GET days/:day_id/meals/:meal_id/foods/1 or days/:day_id/meals/:meal_id/foods/1.json
      def show
      end

      # GET days/:day_id/meals/:meal_id/foods/new
      def new
        @food = @meal.foods.build
      end

      # GET days/:day_id/meals/:meal_id/foods/1/edit
      def edit
      end

      # POST days/:day_id/meals/:meal_id/foods or days/:day_id/meals/:meal_id/foods.json
      def create
        @food = @meal.foods.build(food_params)

        respond_to do |format|
          if @food.save
            format.html { redirect_to day_meal_food_url(@day, @meal, @food), notice: "Food was successfully created." }
            format.json { render :show, status: :created, location: @food }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @food.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT days/:day_id/meals/:meal_id/foods/1 or days/:day_id/meals/:meal_id/foods/1.json
      def update
        respond_to do |format|
          if @food.update(food_params)
            format.html { redirect_to day_meal_food_url(@day, @meal, @food), notice: "Food was successfully updated." }
            format.json { render :show, status: :ok, location: @food }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @food.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE days/:day_id/meals/:meal_id/foods/1 or days/:day_id/meals/:meal_id/foods/1.json
      def destroy
        @food.destroy!

        respond_to do |format|
          format.html { redirect_to foods_url, notice: "Food was successfully destroyed." }
          format.json { head :no_content }
        end
      end

      private

      def set_day
        @day = Day.find(params[:day_id])
      end

      def set_meal
        @meal = @day.meals.find(params[:meal_id])
      end
      # Use callbacks to share common setup or constraints between actions.
      def set_food
        @food = @meal.foods.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def food_params
        params.fetch(:food, {})
      end
    end
  end
end
