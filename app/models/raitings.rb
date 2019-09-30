class Raitings
  def self.all(imdb_id)
    params = {
      i: imdb_id,
      apikey: Rails.application.config.omdb_api_key
    }
    response = connection.get("", params)

    if response.success?
      response.body["Ratings"]
    else
      []
    end
  end

  private

    def self.connection
      Faraday.new("http://www.omdbapi.com/") do |conn|

        conn.request :json
        #retry Time-Outs
        conn.request :retry, interval: 0.05, interval_randomness: 0.5,
                      backoff_factor: 2
        #response middleware config
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end
end
