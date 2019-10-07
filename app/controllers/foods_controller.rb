class FoodsController < ApplicationController
  helper_method :establishments, :cuisines, :sort_options

  def index
    params[:search] ||= {}
    @sort = params[:search][:sort] || "real_distance"
    @establishment = params[:search][:establishment_id]
    @cuisine = params[:search][:cuisine]

    @restaurants = Rails.cache.fetch(cache_key) do
      Restaurant.search_for(current_account, @establishment, @cuisine, @sort)
    end

    if request.xhr?
      render partial: "foods/table", locals: {restaurants: @restaurants}, status: 200
    end
  end

  def show
  end

  def establishments
    @establishments ||= Establishment.get_types(current_account)
  end

  def cuisines
    @cuisines ||= Cuisine.get_all(current_account)
  end

  def sort_options
    [
      {value: "real_distance", text: "Distance"},
      {value: "rating", text: "Raiting"},
      {value: "cost", text: "Cost"}
    ]
  end

  protected

    def cache_key
      # lat;lng;establishment;cuisine;sort"
      "#{current_account.address.latlng};#{@establishment};#{@cuisine};#{@sort}"
    end
end
