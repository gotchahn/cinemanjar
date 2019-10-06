class FoodsController < ApplicationController
  helper_method :establishments, :cuisines
  
  def index
  end

  def show
  end

  def establishments
    @establishments ||= Establishment.get_types(current_account)
  end

  def cuisines
    @cuisines ||= Cuisine.get_all(current_account)
  end
end
