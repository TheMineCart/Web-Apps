#    Copyright (C) 2012 Cyrus Innovation

require 'mongo'
require 'bson'

class MongoConnection
  attr_accessor :connection

  def initialize(address = "localhost")
    @connection = Mongo::Connection.new(address)
  end

  def get_db(db_name)
    @connection.db(db_name)
  end

end