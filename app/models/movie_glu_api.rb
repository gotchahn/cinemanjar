require "faraday"

class MovieGluApi
  include Parseable

  def self.headers
    {
      "client" => Rails.application.config.movie_glu_username,
      "x-api-key" => Rails.application.config.movie_glu_api_key,
      "authorization" => "Basic #{Rails.application.config.movie_glu_password}" ,
      "api-version" => "v200",
      "territory" => "US"
    }
  end

  def self.connection
    Faraday.new("https://api-gate2.movieglu.com/", { headers: headers }) do |conn|
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
