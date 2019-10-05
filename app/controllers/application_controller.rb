class ApplicationController < ActionController::Base
  helper_method :current_account
  before_action :authenticate

  def current_account
    if session[:account_id].present?
      @current_account = Account.preload(:movie_picks).find(session[:account_id])
    end
  end

  def login(account)
    session[:account_id] = account.id
    cookies[:username] = account.username
  end

  def authenticate
    return if current_account.present?
    redirect_to root_path
  end
end
