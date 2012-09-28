#    Copyright (C) 2012 Cyrus Innovation

require 'date'

helpers do
  SECONDS_IN_A_DAY = 86400

  def parseTime(time)
    Time.parse(time)
  end

  def parseDate(time)
    Date.parse(time)
  end

  def formatTime(time)
    parseTime(time).strftime("%m/%d/%Y - %l:%M %p %z")
  end

  def minutesPlayed(connected, disconnected)
    Integer((parseTime(disconnected) - parseTime(connected))/60)
  end

  def averageMinutesPlayed(joinedOn, minutesPlayed)
    daysSinceJoinDate = Integer(Date.today - parseDate(joinedOn)) + 1
    (Integer(minutesPlayed)/daysSinceJoinDate).to_i
  end

  def infractionColor(warning)
    warning_level = warning.downcase
    ["minor", "moderate", "major"].map{ |infraction|
      return "#{infraction}-warning" if infraction == warning_level
    }
    "no-warning"
  end

  def eventTypeColor(event_type)
    downcase_type = event_type.downcase

    ["removed", "placed", "unprotected"].map{ |type|
      return "#{type}-type" if type == downcase_type
    }
    ""
  end
end