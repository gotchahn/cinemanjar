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
      redirect_to upcoming_movies_path
    else
      flash[:error] = "Please Fix the Errors"
      render :new
    end
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
end
