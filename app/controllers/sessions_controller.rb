class SessionsController < ApplicationController
  def new
  end

  def create
    @account = Account.find_by_username(params[:session][:username])
    @account ||= Account.find_by_email(params[:session][:username])

    if @account && @account.authenticate(params[:session][:password])
      redirect_to upcoming_movies_path
    else
      render :new
    end
  end
end
