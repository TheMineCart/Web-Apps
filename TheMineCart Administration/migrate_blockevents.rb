require 'sinatra'
require 'mongo'
require 'bson'

get '/' do
  connection = get_mongo_connection
  db = get_db
  blockEvents = get_collection

  stuff = format_line("Local Mongo Databases: ")
  stuff += connection.database_names.join("<br/>")
  stuff += format_line("Collections for BetterProtected:")
  stuff += db.collection_names.join("<br/>")

  blockEvent = blockEvents.find_one
  newEvent = reformat_keys_on(remove_keys_from(blockEvent.dup), blockEvent)

  haml :index, locals: {stuff: stuff, blockEvent: blockEvent, reformatted: newEvent}
end

get '/transform' do

  new_events_on_new_database = get_collection("BlockEvents", get_db("TempDatabase"))
  block_events = get_collection("BlockEvents", get_db("Server3"))

  block_events.find("owner" => {"$exists" => true}).each { |block_event|
    new_event = reformat_keys_on(remove_keys_from(block_event.dup), block_event)
    new_events_on_new_database.insert(new_event)
  }
  #get_collection.remove("owner" => {"$exists" => true})

  haml :transform, locals: {count: block_events.count()}
end

get '/count' do
  haml :count, locals: {count: get_collection.count("owner" => {"$exists" => true})}
end

get '/remove' do
end

def get_mongo_connection(address = "localhost")
  Mongo::Connection.new(address)
end

def get_db(db_name = "TransformProtected")
  get_mongo_connection.db(db_name)
end

def get_collection(collection = "BlockEvents", database = get_db)
  database.collection(collection)
end

def format_line(input)
  "<br/><br/><strong>#{input}</strong><br/>"
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