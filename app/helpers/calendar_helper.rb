module CalendarHelper
  def sign(n)
    "++-"[n <=> 0]
  end
end
