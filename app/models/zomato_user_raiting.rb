class ZomatoUserRaiting
  include Parseable

  attr_accessor :aggregate_rating, :rating_text, :rating_color, :votes
end
