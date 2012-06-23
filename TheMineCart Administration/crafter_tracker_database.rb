require File.dirname(__FILE__) + '/mongo_connection'

class CrafterTrackerDatabase < MongoConnection
  attr_accessor :db, :players, :sessions, :warning_messages

  def initialize(db_name = "CrafterTracker")
    super("localhost")
    @db = get_db(db_name)
    @players = @db.collection("Players")
    @sessions = @db.collection("Sessions")
    @warning_messages = @db.collection("WarningMessages")
  end

end