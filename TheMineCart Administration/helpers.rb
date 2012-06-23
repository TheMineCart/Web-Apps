helpers do
  SECONDS_IN_A_DAY = 86400

  def parseTime(time)
    Time.parse(time)
  end

  def formatTime(time)
    parseTime(time).strftime("%m/%d/%Y - %l:%M %p %z")
  end


  def averageMinutesPlayed(joinedOn, minutesPlayed)
    daysSinceJoinDate = (Time.now - parseTime(joinedOn))/SECONDS_IN_A_DAY
    (Integer(minutesPlayed)/daysSinceJoinDate).to_i
  end
end