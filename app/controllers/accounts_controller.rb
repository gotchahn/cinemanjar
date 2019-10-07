class AccountsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]

  def new
    @account = Account.new
    @account.build_address
  end

  def show
    @movie_picks = current_account.movie_picks.order(created_at: :desc).first(20)
    @food_picks = current_account.food_picks.order(created_at: :desc).first(20)
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      login(@account)
      redirect_to account_path
    else
      flash[:error] = "Please Fix the Errors"
      render :new
    end
  end

  def edit
    @account = current_account
  end

  def update
    @account = current_account

    if @account.update(account_params)
      redirect_to account_path
    else
      flash[:error] = "Please Fix the Errors"
      render :edit
    end
  end

  def edit_password
    @account = current_account
  end

  def favorite_cinema
    cinema = FavoriteCinema.find_by_movie_glu_cinema_id(params[:cinema][:movie_glu_cinema_id])
    cinema ||= FavoriteCinema.create(set_favorite_params)

    current_account.update_column(:favorite_cinema_id, cinema.id)

    redirect_to cinemas_path
  end

  def movie_pick
    mp = current_account.movie_picks.build(movie_pick_params)

    # get movie
    movie = Rails.cache.fetch("movie/#{mp.movie_id}") do
      Movie.find(mp.movie_id)
    end
    mp.movie_name = movie.title
    mp.movie_poster_url = movie.poster_url
    mp.movie_picked_at ||= Date.current

    if mp.save
      current_account.save_new_genres(movie.genres)
      flash[:notice] = "You have picked #{mp.movie_name}, enjoy!"
    else
      flash[:error] = "Something went wrong while picking the show time"
    end

    redirect_to current_account
  end

  def food_pick
    fp = current_account.food_picks.build(food_pick_params)
    # get restaurant
    restaurant = Rails.cache.fetch("restaurant/#{fp.restaurant_id}") do
      Restaurant.find(fp.restaurant_id)
    end
    fp.restaurant_name = restaurant.name
    fp.restaurant_image_url = restaurant.thumb
    fp.cuisines = restaurant.cuisines

    if fp.save
      flash[:notice] = "Enjoy eating at #{fp.restaurant_name}!"
    else
      flash[:error] = "Something went wrong while picking the show time"
    end

    redirect_to current_account
  end

  protected

  def account_params
    params.require(:account).permit(
      :username,
      :name,
      :email,
      :password,
      :password_confirmation,
      address_attributes: [
        :id,
        :street,
        :apt_number,
        :city,
        :state,
        :postal_code
      ]
    )
  end

  def set_favorite_params
    params.require(:cinema).permit(
      :movie_glu_cinema_id,
      :name,
      :address,
      :logo_url
    )
  end

  def movie_pick_params
    params.require(:movie_pick).permit(
      :movie_id,
      :cinema_name,
      :start_time,
      :end_time,
      :movie_picked_at,
      :show_time_type
    )
  end

  def food_pick_params
    params.require(:food_pick).permit(:restaurant_id)
  end
end
