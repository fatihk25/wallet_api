require "uri"
require "net/http"
require "json"

module LatestStockPrice
  class StockService
    BASE_URL = "https://latest-stock-price.p.rapidapi.com/any"
    API_HOST = "latest-stock-price.p.rapidapi.com"

    def initialize(api_key)
      @url = URI(BASE_URL)
      @http = Net::HTTP.new(@url.host, @url.port)
      @http.use_ssl = true
      @api_key = api_key
    end

    def price(identifier)
      response = api_request
      parse_response(response, identifier)
    end

    def prices(identifiers)
      response = api_request
      results = identifiers.map { |id| parse_response(response, id) }.compact
      results
    end

    private

    def api_request
      request = Net::HTTP::Get.new(@url)
      request["x-rapidapi-key"] = @api_key
      request["x-rapidapi-host"] = API_HOST
      response = @http.request(request)
      JSON.parse(response.body)
    rescue => e
      { error: "Error fetching data: #{e.message}" }
    end

    def parse_response(response, identifier)
      stock_data = response.find { |stock| stock["identifier"] == identifier }
      return unless stock_data

      {
        identifier: stock_data["identifier"],
        last_price: stock_data["lastPrice"],
        day_high: stock_data["dayHigh"],
        day_low: stock_data["dayLow"],
        change: stock_data["change"],
        company_name: stock_data.dig("meta", "companyName"),
        last_update: stock_data["lastUpdateTime"]
      }
    end
  end
end
