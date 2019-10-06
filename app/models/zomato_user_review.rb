class ZomatoUserReview
  include Parseable

  attr_accessor :rating, :review_text, :rating_color, :review_time_friendly, :rating_text, :user
end
