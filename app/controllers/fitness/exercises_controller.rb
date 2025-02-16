class Fitness::ExercisesController < ApplicationController
  before_action :set_fitness_exercise, only: %i[ show edit update destroy ]

  # GET /fitness/exercises or /fitness/exercises.json
  def index
    @fitness_exercises = Fitness::Exercise.all
  end

  # GET /fitness/exercises/1 or /fitness/exercises/1.json
  def show
  end

  # GET /fitness/exercises/new
  def new
    @fitness_exercise = Fitness::Exercise.new
  end

  # GET /fitness/exercises/1/edit
  def edit
  end

  # POST /fitness/exercises or /fitness/exercises.json
  def create
    @fitness_exercise = Fitness::Exercise.new
    @fitness_exercise.assign_attributes(fitness_exercise_params)

    respond_to do |format|
      if @fitness_exercise.save
        format.html { redirect_to @fitness_exercise, notice: "Exercise was successfully created." }
        format.json { render :show, status: :created, location: @fitness_exercise }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fitness_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fitness/exercises/1 or /fitness/exercises/1.json
  def update
    @fitness_exercise.assign_attributes(fitness_exercise_params)
    puts(fitness_exercise_params.inspect)
    respond_to do |format|
      if @fitness_exercise.save
        format.html { redirect_to @fitness_exercise, notice: "Exercise was successfully updated." }
        format.json { render :show, status: :ok, location: @fitness_exercise }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fitness_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fitness/exercises/1 or /fitness/exercises/1.json
  def destroy
    @fitness_exercise.destroy!

    respond_to do |format|
      format.html { redirect_to fitness_exercises_path, status: :see_other, notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_fitness_exercise
    @fitness_exercise = Fitness::Exercise.includes(exercise_tags: :tag) .find(params[:id])
  end

  def fitness_exercise_params
    params.require(:fitness_exercise)
      .permit(
        :name,
        :description,
        :demonstration_youtube_url,
        :warmup_strategy,
        tag_ids: [],
    ).tap do |p|
      tags = Set.new
      p[:exercise_tags_attributes] = p.delete(:tag_ids).filter_map do |tag_id|
        next if tag_id.blank?

        tags.add(tag_id.to_i)
        { tag_id: tag_id.to_i }
      end
      existing_tags = @fitness_exercise.exercise_tags.index_by(&:tag_id)
      p[:exercise_tags_attributes].each do |tag|
        if existing_tags[tag[:tag_id]]
          exercise_tag = existing_tags.delete(tag[:tag_id])
          tag[:id] = exercise_tag.id
          tag[:exercise_id] = @fitness_exercise.id
        end
      end

      existing_tags.each do |tag_id, exercise_tag|
        p[:exercise_tags_attributes] << { id: exercise_tag.id, _destroy: true }
      end

      p.permit!
    end
  end
end
