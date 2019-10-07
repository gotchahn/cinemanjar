require 'faraday'

class TheMovieDbApi
  include Parseable

  def self.the_movie_db_api_url
    "https://api.themoviedb.org/3/"
  end

  def self.connection

    Faraday.new(the_movie_db_api_url) do |conn|

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

  def self.get(endpoint_url, params={})
    params.reverse_merge!(
      api_key: Rails.application.credentials.the_movie_db[:api_key],
      language: "en-US",
      region: "US"
    )

    connection.get(endpoint_url, params)
  end
end
