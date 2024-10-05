class FoodSearchController < ApplicationController
  def search
    query = params[:query].strip

    return head(:no_content) if query.blank?

    parts = query.split(" ")

    internal_foods = Food.all
    parts.map { |part| "%#{part.upcase}%" }.each do |bind|
      internal_foods = internal_foods.where("UPPER(foods.name) LIKE ?", bind)
    end

    # TODO: Can I stream individual data sources as they come in?
    # Maybe I can use a turbo stream broadcast?
    # I would have to watch out for slow results being inserted into result boxes for queries that
    # have changed out from under them
    # Maybe that's just a problem I ignore?
    # I could intercept with some javascript and filter those out client side
    # Problems
    #  - Ordering of results becomes non-deterministic
    #  - I would have to replace the current results box (one per food entry) with a single one per meal that moves around
    #  - Ideally I would like to show the user that the search is still in progress, but that would require some way to know
    #    once all results have been returned (or stopped from errors)
    #    I could return a list of data sources in the main response, and then have the client keep track of which ones have
    #    come in. But if something goes wrong with one of them it will be expecting more results forever
    # I could also use SSE, that might be easier
    #  - https://medium.com/@thilonel/how-to-use-rails-actioncontroller-live-sse-server-sent-events-d9a04a286f77
    #  - https://fbazzarella.medium.com/streaming-data-with-server-sent-events-b0694e6e0b32

    internal_foods = internal_foods
      .distinct
      .pluck(
        :id,
        :name,
        :kilocalories,
        :unit,
        :quantity,
      ).map do |id, name, fk, fu, fq|
      {
        food_id: id,
        food_name: name,
        food_kilocalories: fk,
        food_quantity: fq,
        food_unit: Food.units[fu],
        unit: nil,
        quantity: nil
      }
    end

    cl = FoodData::Client.new

    # Assumption: All data retured for foods in the Foundation dataset are in 100g portions
    #             These foods may have other quantities, but they API does not seem to return them
    foundation = []
    # foundation = Rails.cache.fetch("food_data:foundation:#{query}", expires_in: 1.day) do
    #   cl.search(query, data_type: [ "Foundation" ])["foods"].filter_map do |food_data|
    #     next if food_data["score"] < 100 # TODO: Arbitrary threshold
    #
    #     food_name = food_data["description"]
    #
    #     energy_values = food_data["foodNutrients"].filter do |fn|
    #       fn["nutrientName"].start_with?("Energy")
    #     end
    #
    #     energy = begin
    #       # TODO: If mulitple energy values are present, have an opinion on which to pick
    #       nutrient = energy_values.first
    #       next if nutrient.nil?
    #
    #       value = nutrient["value"]
    #
    #       if nu = nutrient["unitName"]
    #         case nu
    #         when "KCAL"
    #           value
    #         when "kJ"
    #           value * 0.239005736
    #         else
    #           raise "Unknown unit: #{nu}"
    #         end
    #       else
    #         value
    #       end
    #     end
    #
    #     {
    #       food_id: nil,
    #       food_name:,
    #       food_kilocalories: energy.round(0),
    #       food_quantity: 100,
    #       food_unit: "g",
    #       unit: nil,
    #       quantity: nil
    #     }
    #   end
    # end

    branded = []
    # branded = Rails.cache.fetch("food_data:branded:#{query}", expires_in: 1.day) do
    #   cl.search(query, data_type: [ "Branded" ])["foods"].filter_map do |food_data|
    #     next if food_data["score"] < 500 # TODO: Arbitrary threshold
    #
    #     food_name = food_data["description"]
    #     brand = food_data["brandName"] || food_data["brandOwner"]
    #     food_name += " (#{brand})" unless brand.blank?
    #
    #     # Noramlize units
    #     food_unit = case su = food_data["servingSizeUnit"]
    #     when "GRM"
    #         "g"
    #     when "MLT"
    #         "ml"
    #     else
    #         su
    #     end
    #
    #     energy_values = food_data["foodNutrients"].filter do |fn|
    #       fn["nutrientName"].start_with?("Energy")
    #     end
    #
    #     energy = begin
    #       # TODO: If mulitple energy values are present, have an opinion on which to pick
    #       nutrient = energy_values.first
    #
    #       # Some branded foods seem to omit energy values
    #       # We require them to be present, so we skip those foods
    #       next if nutrient.nil?
    #       value = nutrient["value"]
    #
    #       if nu = nutrient["unitName"]
    #         case nu
    #         when "KCAL"
    #           value
    #         when "kJ"
    #           value * 0.239005736
    #         else
    #           raise "Unknown unit: #{nu}"
    #         end
    #       else
    #         value
    #       end
    #     end
    #
    #     {
    #       food_id: nil,
    #       food_name:,
    #       food_kilocalories: energy.round(0),
    #       food_quantity: 100,
    #       food_unit:,
    #       unit: nil,
    #       quantity: nil
    #     }
    #   end
    # end

    foods = internal_foods + foundation + branded

    # TODO: Can we filter to specific brands?
    #       I can't think of how to do that without an explicit brand field
    # TODO: Use other data types if Foundation doesn't return results
    #       - Survey (FNDDS)
    #       - SR Legacy
    #       I would rather use foundation if it's available, but it's a very small dataset.
    #       Perhaps we do Foundation first, then do all these other ones in one request if empty?
    # TODO: How to order results such that the better ones come first
    #       We could interleave the various sources? Presumably each is in order of quality within that source

    render partial: "food_search/results", locals: { foods: }
  end
end
