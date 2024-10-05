class FoodData::Client
  def initialize(page_size: 50)
    @client = Faraday.new("https://api.nal.usda.gov") do |conn|
      conn.params["api_key"] = ENV["DATA_GOV_API_KEY"]
      conn.request :json
      conn.response :json
    end
  end

  def get_food(id)
    response = @client.get("/fdc/v1/food/#{id}")
    response.body
  end

  def search(query, data_type: [ "Foundation" ], brand_owner: nil, page_size: 50, page_number: 1)
    response = @client.post("/fdc/v1/foods/search") do |req|
      req.body = {
        query: query,
        dataType: data_type,
        brandOwner: brand_owner,
        pageSize: page_size,
        pageNumber: page_number
      }
    end

    response.body
  end
end
