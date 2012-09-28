#    Copyright (C) 2012 Cyrus Innovation

require File.dirname(__FILE__) + '/mongo_connection'

class BetterProtectedDatabase < MongoConnection
  attr_accessor :db, :block_events, :players

  def initialize(db_name = "BetterProtected")
    super("localhost")
    @db = get_db(db_name)
    @block_events = @db.collection("BlockEvents")
    @players = @db.collection("Players")
  end

end