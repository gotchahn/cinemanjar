class MovieGluCinema < MovieGluApi
  attr_accessor :cinema_id, :cinema_name, :address, :address2, :city,
    :postcode, :distance, :logo_url

  def self.nearby(current_account, limit=5)
    response = connection.get("cinemasNearby/", { n: limit }) do |request|
      request.headers["geolocation"] = current_account.address.latlng
      request.headers["device-datetime"] = Time.now.utc.iso8601
    end

    body = response.success? ? response.body["cinemas"] : test_cinamas_list
    source_to_collection( body )
  end

  def self.find(movie_glu_cinema_id, geolocation)
     response = connection.get("cinemaDetails/", { cinema_id: movie_glu_cinema_id }) do |request|
      request.headers["geolocation"] = geolocation
      request.headers["device-datetime"] = Time.now.utc.iso8601
     end

     body = response.status == 200 ? response.body : test_cinema_details_body
     new( body )
  end

  # date must be YYYY-MM-DD format
  def now_playing(date= nil)
    date ||= Time.now.strftime("%Y-%m-%d")
    params = {
      cinema_id: cinema_id,
      date: date
    }

    response = self.class.connection.get("cinemaShowTimes/", params) do |request|
      request.headers["device-datetime"] = Time.now.utc.iso8601
    end

    body = response.status == 200 ? response.body["films"] : test_now_playing["films"]
    self.class.source_to_collection(body, MovieShowTime)
  end

  def full_address
    address1 = [address, address2].join(" ")
    [address1, city, postcode].join(", ")
  end

  def nice_distance
    distance.round(1)
  end

  private

    # in case I reach the 75 quota limit ==========
    def self.test_cinamas_list
      [{"cinema_id"=>10826, "cinema_name"=>"AMC Orchard 12", "address"=>"14653 Orchard Parkway", "address2"=>"", "city"=>"Westminster", "county"=>"Adams", "postcode"=>80023, "lat"=>39.958038, "lng"=>-104.993698, "distance"=>2.728902829367, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-124-sq.jpg"}, {"cinema_id"=>4196, "cinema_name"=>"AMC Westminster Promenade 24", "address"=>"10655 Westminster Boulevard", "address2"=>"", "city"=>"Westminster", "county"=>"Jefferson", "postcode"=>80020, "lat"=>39.889198, "lng"=>-105.070702, "distance"=>4.7864050442819, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-124-sq.jpg"}, {"cinema_id"=>49307, "cinema_name"=>"Alamo Drafthouse Cinema - Westminster", "address"=>"8905 Westminster Boulevard", "address2"=>"", "city"=>"Westminster", "county"=>"Jefferson", "postcode"=>80031, "lat"=>39.863892, "lng"=>-105.062698, "distance"=>5.4415338942847, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-772-sq.jpg"}, {"cinema_id"=>2980, "cinema_name"=>"88 Drive-In Theatre", "address"=>"8780 Rosemary Street", "address2"=>"", "city"=>"Commerce City", "county"=>"Adams", "postcode"=>80022, "lat"=>39.855728, "lng"=>-104.899597, "distance"=>6.4350659008204, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-0-sq.jpg"}, {"cinema_id"=>8058, "cinema_name"=>"AMC Flatiron Crossing 14", "address"=>"61 West Flatiron Circle", "address2"=>"", "city"=>"Broomfield", "county"=>"Broomfield", "postcode"=>80021, "lat"=>39.929722, "lng"=>-105.130898, "distance"=>7.5572611456764, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-124-sq.jpg"}, {"cinema_id"=>732, "cinema_name"=>"Elvis Cinemas Arvada 8", "address"=>"5157 West 64th Avenue", "address2"=>"", "city"=>"Arvada", "county"=>"Adams", "postcode"=>80003, "lat"=>39.812939, "lng"=>-105.052597, "distance"=>8.0490872264287, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-661-sq.jpg"}, {"cinema_id"=>48038, "cinema_name"=>"Harkins Arvada 14", "address"=>"5550 Olde Wadsworth Boulevard", "address2"=>"", "city"=>"Arvada", "county"=>"Jefferson", "postcode"=>80002, "lat"=>39.7976, "lng"=>-105.080101, "distance"=>9.6630922939511, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-397-sq.jpg"}, {"cinema_id"=>9314, "cinema_name"=>"AMC Brighton 12", "address"=>"250 Pavillions Place", "address2"=>"", "city"=>"Brighton", "county"=>"Adams", "postcode"=>80601, "lat"=>39.982841, "lng"=>-104.823601, "distance"=>9.8184632571463, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-124-sq.jpg"}, {"cinema_id"=>2954, "cinema_name"=>"Regal Cinebarre Boulder", "address"=>"1164 West Dillon Road", "address2"=>"", "city"=>"Louisville", "county"=>"Boulder", "postcode"=>80027, "lat"=>39.959862, "lng"=>-105.167503, "distance"=>9.8748055069018, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-118-sq.jpg"}, {"cinema_id"=>9967, "cinema_name"=>"Harkins Northfield 18", "address"=>"8300 E. Northfield Boulevard", "address2"=>"", "city"=>"Denver", "county"=>"Denver", "postcode"=>80238, "lat"=>39.785191, "lng"=>-104.891899, "distance"=>10.56647861884, "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-397-sq.jpg"}]
    end

    def self.test_cinema_details_body
      {"cinema_id"=>10826, "cinema_name"=>"AMC Orchard 12", "address"=>"14653 Orchard Parkway", "address2"=>"", "city"=>"Westminster", "county"=>"Adams", "country"=>"USA", "postcode"=>80023, "phone"=>"(303)920-1222", "lat"=>39.958038, "lng"=>-104.993698, "distance"=>2.728902829367, "ticketing"=>0, "directions"=>"", "logo_url"=>"https://assets.movieglu.com/chain_logos/us/UK-124-sq.jpg", "show_dates"=>[{"date"=>"2019-10-06"}, {"date"=>"2019-10-07"}, {"date"=>"2019-10-08"}, {"date"=>"2019-10-09"}, {"date"=>"2019-10-10"}, {"date"=>"2019-10-11"}, {"date"=>"2019-10-12"}, {"date"=>"2019-10-13"}, {"date"=>"2019-10-14"}, {"date"=>"2019-10-15"}, {"date"=>"2019-10-16"}, {"date"=>"2019-10-17"}, {"date"=>"2019-10-18"}, {"date"=>"2019-10-19"}, {"date"=>"2019-10-20"}, {"date"=>"2019-10-21"}, {"date"=>"2019-10-22"}, {"date"=>"2019-10-23"}, {"date"=>"2019-10-24"}, {"date"=>"2019-10-25"}, {"date"=>"2019-10-26"}, {"date"=>"2019-10-27"}, {"date"=>"2019-10-28"}, {"date"=>"2019-10-29"}, {"date"=>"2019-10-30"}, {"date"=>"2019-10-31"}, {"date"=>"2019-11-04"}, {"date"=>"2019-11-06"}, {"date"=>"2019-11-07"}, {"date"=>"2019-11-09"}, {"date"=>"2019-11-10"}, {"date"=>"2019-11-11"}, {"date"=>"2019-11-12"}, {"date"=>"2019-11-13"}, {"date"=>"2019-11-14"}, {"date"=>"2019-11-15"}, {"date"=>"2019-11-16"}, {"date"=>"2019-11-17"}, {"date"=>"2019-11-18"}, {"date"=>"2019-11-19"}, {"date"=>"2019-11-20"}, {"date"=>"2019-11-21"}, {"date"=>"2019-11-22"}, {"date"=>"2019-11-23"}, {"date"=>"2019-11-24"}, {"date"=>"2019-12-01"}, {"date"=>"2019-12-03"}, {"date"=>"2019-12-07"}, {"date"=>"2019-12-08"}, {"date"=>"2019-12-09"}, {"date"=>"2019-12-11"}, {"date"=>"2019-12-15"}, {"date"=>"2019-12-16"}, {"date"=>"2019-12-18"}, {"date"=>"2020-01-11"}, {"date"=>"2020-01-26"}, {"date"=>"2020-02-01"}, {"date"=>"2020-02-08"}, {"date"=>"2020-02-18"}, {"date"=>"2020-02-23"}, {"date"=>"2020-02-24"}, {"date"=>"2020-02-25"}, {"date"=>"2020-02-29"}, {"date"=>"2020-03-14"}, {"date"=>"2020-03-29"}], "status"=>{"count"=>1, "state"=>"OK", "method"=>"cinemaDetails", "message"=>nil, "request_method"=>"GET", "version"=>"CINE_30v200", "territory"=>"US", "device_datetime_sent"=>"2019-10-06 04:25:54 UTC", "device_datetime_used"=>"2019-10-06 04:25:54"}}
    end

    def test_now_playing
      {"cinema"=>{
          "cinema_id"=>10826, "cinema_name"=>"AMC Orchard 12"
        },
        "films"=>[
            { "film_id"=>243084,
              "imdb_id"=>6324278,
              "film_name"=>"Abominable",
              "version_type"=>"Standard",
              "age_rating"=>[
                {"rating"=>"PG ",
                  "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/pg.png",
                  "age_advisory"=>"for some action and mild rude humor"}
              ],
              "images"=>{
                "poster"=>{
                  "1"=>{
                    "image_orientation"=>"portrait",
                    "region"=>"global",
                    "medium"=>{
                      "film_image"=>"https://image.movieglu.com/243084/AUS_243084h0.jpg",
                      "width"=>189, "height"=>300
                    }
                  }
                },
                "still"=>{
                  "1"=>{
                    "image_orientation"=>"landscape",
                    "medium"=>{
                      "film_image"=>"https://image.movieglu.com/243084/243084h2.jpg",
                      "width"=>300,
                      "height"=>200
                    }
                  }
                }
              },
              "showings"=>{
                "Standard"=>{
                  "film_id"=>243084,
                  "film_name"=>"Abominable",
                  "times"=>[
                    {"start_time"=>"08:30",
                      "end_time"=>"09:57"
                    },
                    {"start_time"=>"09:00",
                      "end_time"=>"10:57"
                    },
                    {"start_time"=>"11:30",
                      "end_time"=>"13:00"
                    },
                    {"start_time"=>"12:55",
                      "end_time"=>"14:15"
                    },
                    {"start_time"=>"14:00",
                      "end_time"=>"15:57"
                    },
                    {"start_time"=>"15:00",
                      "end_time"=>"16:57"
                    },
                    {"start_time"=>"17:30",
                      "end_time"=>"19:27"
                    },
                    {"start_time"=>"19:00",
                      "end_time"=>"20:57"
                    }
                  ]
                },
                "3D"=>{
                  "film_id"=>293745,
                  "film_name"=>"Abominable in RealD 3D",
                  "times"=>[{"start_time"=>"16:30", "end_time"=>"18:27"}]
                },
                "IMAX"=>{
                  "film_id"=>293745,
                  "film_name"=>"Abominable in RealD 3D",
                  "times"=>[{"start_time"=>"14:00",
                    "end_time"=>"15:57"
                  },
                  {"start_time"=>"15:00",
                    "end_time"=>"16:57"
                  },{"start_time"=>"16:30", "end_time"=>"18:27"}]
                }
              },
              "show_dates"=>[
                {"date"=>"2019-10-01"},
                {"date"=>"2019-10-02"},
                {"date"=>"2019-10-03"},
                {"date"=>"2019-10-04"},
                {"date"=>"2019-10-05"},
                {"date"=>"2019-10-06"}
              ]
            },
            {"film_id"=>275906, "imdb_id"=>6398184, "film_name"=>"Downton Abbey", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"PG ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/pg.png", "age_advisory"=>"for thematic elements, some suggestive material, and language"}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/275906/AUS_275906h0.jpg", "width"=>202, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/275906/275906h2.jpg", "width"=>300, "height"=>200}}}}, "showings"=>{"Standard"=>{"film_id"=>275906, "film_name"=>"Downton Abbey", "times"=>[{"start_time"=>"14:00", "end_time"=>"16:26"}, {"start_time"=>"16:45", "end_time"=>"19:11"}, {"start_time"=>"19:30", "end_time"=>"21:56"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}]}, {"film_id"=>288732, "imdb_id"=>1206885, "film_name"=>"Rambo: Last Blood", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"R ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/r.png", "age_advisory"=>"strong graphic violence, grisly images, drug use and language"}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/288732/288732h1.jpg", "width"=>200, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/288732/288732h2.jpg", "width"=>300, "height"=>200}}}}, "showings"=>{"Standard"=>{"film_id"=>288732, "film_name"=>"Rambo: Last Blood", "times"=>[{"start_time"=>"15:00", "end_time"=>"16:54"}, {"start_time"=>"17:30", "end_time"=>"19:24"}, {"start_time"=>"20:00", "end_time"=>"21:54"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}]}, {"film_id"=>277157, "imdb_id"=>5503686, "film_name"=>"Hustlers", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"R ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/r.png", "age_advisory"=>"for pervasive sexual material, drug content, language and nudity"}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/277157/277157h1.jpg", "width"=>200, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/277157/277157h2.jpg", "width"=>300, "height"=>199}}}}, "showings"=>{"Standard"=>{"film_id"=>277157, "film_name"=>"Hustlers", "times"=>[{"start_time"=>"14:05", "end_time"=>"16:19"}, {"start_time"=>"17:00", "end_time"=>"19:14"}, {"start_time"=>"20:00", "end_time"=>"22:14"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}]}, {"film_id"=>257539, "imdb_id"=>2935510, "film_name"=>"Ad Astra", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"PG-13 ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/pg-13.png", "age_advisory"=>"for some violence and bloody images, and for brief strong language"}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/257539/AUS_257539h0.jpg", "width"=>204, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/257539/257539h2.jpg", "width"=>300, "height"=>200}}}}, "showings"=>{"Standard"=>{"film_id"=>257539, "film_name"=>"Ad Astra", "times"=>[{"start_time"=>"15:00", "end_time"=>"17:27"}, {"start_time"=>"18:00", "end_time"=>"20:27"}]}, "IMAX"=>{"film_id"=>295919, "film_name"=>"Ad Astra: The IMAX 2D Experience", "times"=>[{"start_time"=>"14:00", "end_time"=>"16:27"}, {"start_time"=>"17:00", "end_time"=>"19:27"}, {"start_time"=>"20:00", "end_time"=>"22:27"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}]}, {"film_id"=>258092, "imdb_id"=>7349950, "film_name"=>"It Chapter Two", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"R ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/r.png", "age_advisory"=>"for disturbing violent content and bloody images throughout, pervasive language, and some crude sexual material"}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/258092/258092h1.jpg", "width"=>200, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/258092/258092h2.jpg", "width"=>300, "height"=>200}}}}, "showings"=>{"Standard"=>{"film_id"=>258092, "film_name"=>"It Chapter Two", "times"=>[{"start_time"=>"14:00", "end_time"=>"17:14"}, {"start_time"=>"15:30", "end_time"=>"18:44"}, {"start_time"=>"18:00", "end_time"=>"21:14"}, {"start_time"=>"20:00", "end_time"=>"23:14"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}]}, {"film_id"=>249998, "imdb_id"=>6105098, "film_name"=>"The Lion King", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"PG ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/pg.png", "age_advisory"=>"for sequences of violence and peril, and some thematic elements"}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/249998/249998h1.jpg", "width"=>200, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/249998/249998h2.jpg", "width"=>300, "height"=>200}}}}, "showings"=>{"Standard"=>{"film_id"=>249998, "film_name"=>"The Lion King", "times"=>[{"start_time"=>"14:00", "end_time"=>"16:23"}, {"start_time"=>"16:20", "end_time"=>"18:43"}, {"start_time"=>"19:20", "end_time"=>"21:43"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}]}, {"film_id"=>271749, "imdb_id"=>7343762, "film_name"=>"Good Boys", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"R ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/r.png", "age_advisory"=>"for strong crude sexual content, drug and alcohol material, and language throughout - all involving tweens"}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/271749/271749h1.jpg", "width"=>200, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/271749/271749h2.jpg", "width"=>300, "height"=>200}}}}, "showings"=>{"Standard"=>{"film_id"=>271749, "film_name"=>"Good Boys", "times"=>[{"start_time"=>"17:00", "end_time"=>"18:54"}, {"start_time"=>"19:15", "end_time"=>"21:09"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}]}, {"film_id"=>278037, "imdb_id"=>3387520, "film_name"=>"Scary Stories to Tell In The Dark", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"PG-13 ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/pg-13.png", "age_advisory"=>"for terror/violence, disturbing images, thematic elements, language including racial epithets, and brief sexual references"}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/278037/278037h1.jpg", "width"=>200, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/278037/278037h2.jpg", "width"=>300, "height"=>200}}}}, "showings"=>{"Standard"=>{"film_id"=>278037, "film_name"=>"Scary Stories to Tell In The Dark", "times"=>[{"start_time"=>"15:25", "end_time"=>"17:41"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}]}, {"film_id"=>64620, "imdb_id"=>780521, "film_name"=>"The Princess and the Frog", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"G ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/g.png", "age_advisory"=>""}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/64620/064620h1.jpg", "width"=>200, "height"=>300}}}, "still"=>{"1"=>{"image_orientation"=>"landscape", "medium"=>{"film_image"=>"https://image.movieglu.com/64620/064620h2.jpg", "width"=>300, "height"=>200}}}}, "showings"=>{"Standard"=>{"film_id"=>64620, "film_name"=>"The Princess and the Frog", "times"=>[{"start_time"=>"14:00", "end_time"=>"16:00"}, {"start_time"=>"18:00", "end_time"=>"20:00"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}, {"date"=>"2019-10-02"}, {"date"=>"2019-10-03"}]}, {"film_id"=>288263, "imdb_id"=>nil, "film_name"=>"The Secret World of Arrietty - Studio Ghibli Fest 2019", "version_type"=>"Standard", "age_rating"=>[{"rating"=>"0 ", "age_rating_image"=>"https://assets.movieglu.com/age_rating_logos/us/uc.png", "age_advisory"=>""}], "images"=>{"poster"=>{"1"=>{"image_orientation"=>"portrait", "region"=>"global", "medium"=>{"film_image"=>"https://image.movieglu.com/288263/288263h1.jpg", "width"=>200, "height"=>300}}}}, "showings"=>{"Standard"=>{"film_id"=>288263, "film_name"=>"The Secret World of Arrietty - Studio Ghibli Fest 2019", "times"=>[{"start_time"=>"19:00", "end_time"=>"21:15"}]}}, "show_dates"=>[{"date"=>"2019-10-01"}]}]}
    end
end

#curl "https://api-gate2.movieglu.com/cinemasNearby/?n=5" -H "geolocation: 39.919404;-104.9908763" -H "api-version: v200" -H "Authorization: Basic Q0lORV8zMDpzT1hiZGZiNjZ5dm8=" -H "x-api-key: B7kYVdTc382DOsDULk6NjkCpUGwil5M8KEbpNOdb" -H "device-datetime: 2019-09-23T10:45:30.147Z" -H "territory: US" -H "client: CINE_30"
