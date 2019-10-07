require "faraday"

class ZomatoApi
  include Parseable

  def self.headers
    {
      "user-key" => Rails.application.credentials.zomato[:api_key]
    }
  end

  def self.connection
    Faraday.new("https://developers.zomato.com/api/v2.1/", { headers: headers }) do |conn|
      conn.request :json
      #retry Time-Outs
      conn.request :retry, interval: 0.05, interval_randomness: 0.5,
                    backoff_factor: 2
      #response middleware config
      conn.response :dates
      conn.response :json
      conn.adapter Faraday.default_adapter
    end
  end
end
