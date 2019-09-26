class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(new_account_params)

    if @account.save
      redirect_to upcoming_movies_path
    else
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
      :password_confirmation
    )
  end
end
