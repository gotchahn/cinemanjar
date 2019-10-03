class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
  end

  def create
    @account = Account.find_by_username_or_email(params[:session][:username])

    if @account && @account.authenticate(params[:session][:password])
      login(@account)
      redirect_to account_path
    else
      flash[:error] = "Username or password incorrect"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
