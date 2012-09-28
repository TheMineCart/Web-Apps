# Copyright (C) 2012 Cyrus Innovation

require 'mongo'
require 'bson'

def get_mongo_connection(address = "localhost")
  Mongo::Connection.new(address)
end

def get_db(db_name = "TransformProtected")
  get_mongo_connection.db(db_name)
end

def get_collection(collection = "BlockEvents", database = get_db)
  database.collection(collection)
end

def remove_keys_from(bson_object)
  bson_object.delete("_id")
  bson_object.delete("instant")
  bson_object.delete("owner")
  bson_object.delete("blockEventType")
  bson_object.delete("blockCoordinate")
  bson_object.delete("chunkCoordinate")
  bson_object.delete("world")
  bson_object.delete("material")
  bson_object
end

def reformat_keys_on(bson_object, original)
  bson_object["i"] = original["instant"]
  bson_object["o"] = original["owner"]["username"]
  bson_object["e"] = original["blockEventType"]
  bson_object["b"] = original["blockCoordinate"]
  bson_object["c"] = original["chunkCoordinate"]
  bson_object["w"] = original["world"]["name"]
  bson_object["m"] = original["material"]
  bson_object
end

def transform_and_copy_block_events
  new_events_on_new_database = get_collection("BlockEvents", get_db("BetterProtected"))
  block_events = get_collection("BlockEvents", get_db("BetterProtected"))

  count = 0.0
  max_count = block_events.count.to_f

  puts "Beginning Block Event Transfer"

  block_events.find("owner" => {"$exists" => true}).each { |block_event|
    new_event = reformat_keys_on(remove_keys_from(block_event.dup), block_event)
    new_events_on_new_database.insert(new_event)
    puts "#{((count/max_count)*100)}% transformed." if(count.to_i%10000 == 0)
    count = count + 1.0
  }

  puts "Finished Block Event Transfer"
end

def copy_players
  new_players = get_collection("Players", get_db("BetterProtected"))
  old_players = get_collection("Players", get_db("BetterProtected"))

  count = 0.0
  max_count = old_players.count.to_f

  puts "Beginning Player Transfer"

  old_players.find.each { |player|
    new_players.insert(player)
    puts "#{((count/max_count)*100)}% transformed." if(count.to_i%10 == 0)
    count = count + 1.0
  }

  puts "Finished Player Transfer"
end

transform_and_copy_block_events
copy_players
