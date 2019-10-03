class AccountsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]

  def new
    @account = Account.new
    @account.build_address
  end

  def show
  end

  def create
    @account = Account.new(new_account_params)

    if @account.save
      login(@account)
      redirect_to account_path
    else
      flash[:error] = "Please Fix the Errors"
      render :new
    end
  end

  def favorite_cinema
    # current_account is read only
    account = Account.find(current_account.id)
    cinema = FavoriteCinema.find_by_movie_glu_cinema_id(params[:cinema][:movie_glu_cinema_id])
    cinema ||= FavoriteCinema.create(set_favorite_params)

    account.update_column(:favorite_cinema_id, cinema.id)

    redirect_to cinemas_path
  end

  protected

  def new_account_params
    params.require(:account).permit(
      :username,
      :name,
      :email,
      :password,
      :password_confirmation,
      address_attributes: [
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
end
