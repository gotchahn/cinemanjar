module ApplicationHelper

  def nice_date(date)
    date.strftime("%b %d, %Y")
  end

  def nice_showtime(time)
    Time.parse(time).strftime("%I:%M %p")
  end
end
