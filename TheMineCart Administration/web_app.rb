require 'sinatra'
require 'mongo'
require 'bson'

get '/' do
  haml :index
end

