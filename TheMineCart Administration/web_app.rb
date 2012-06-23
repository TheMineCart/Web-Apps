# gem install mongo
# gem install bson
# gem install bson_ext

require 'sinatra'
require File.dirname(__FILE__) + '/better_protected_database'
require File.dirname(__FILE__) + '/crafter_tracker_database.rb'
require File.dirname(__FILE__) + '/helpers'

set :haml, format: :html5, layout: true
enable :logging

better_protected_db = BetterProtectedDatabase.new
crafter_tracker_db = CrafterTrackerDatabase.new

BP_BLOCK_EVENTS = better_protected_db.block_events
BP_PLAYERS = better_protected_db.players

CT_PLAYERS = crafter_tracker_db.players
CT_SESSIONS = crafter_tracker_db.sessions
CT_WARNINGS = crafter_tracker_db.warning_messages

get '/' do
  haml :index
end

get '/player_report/:name' do
  bp_player = BP_PLAYERS.find_one(username: params[:name])
  ct_player = CT_PLAYERS.find_one(username: params[:name])
  sessions = CT_SESSIONS.find(username: params[:name]).sort(connectedAt: -1).limit(10)
  warnings = CT_WARNINGS.find(recipient: params[:name])

  haml :player_report, locals: {bp_player: bp_player, ct_player: ct_player, sessions: sessions, warnings: warnings}
end

get '/block_history' do
  haml :block_history
end