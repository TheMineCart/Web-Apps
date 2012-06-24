# gem install mongo
# gem install bson
# gem install bson_ext

require 'sinatra'
require 'json'
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
  most_recent = CT_SESSIONS.find().sort('disconnectedAt', 'descending').limit(20)
  most_active = CT_PLAYERS.find().sort('minutesPlayed', 'descending').limit(10)
  highest_scores = CT_PLAYERS.find().sort('score', 'descending').limit(10)
  highest_penalties = CT_PLAYERS.find().sort('penaltyScore', 'descending').limit(10)
  recent_warnings = CT_WARNINGS.find().sort('issuedAt', 'descending').limit(10)

  haml :index, locals: {most_active: most_active,
                        most_recent: most_recent,
                        highest_scores: highest_scores,
                        highest_penalties: highest_penalties,
                        recent_warnings: recent_warnings}
end

get '/player_report' do
  haml :player_report
end

get '/player_info' do
  if exists?(params[:username])
    bp_player = BP_PLAYERS.find_one(username: params[:username])
    ct_player = CT_PLAYERS.find_one(username: params[:username])
    if bp_player && ct_player
      sessions = CT_SESSIONS.find(username: params[:username]).sort('connectedAt', 'descending').limit(30)
      warnings = CT_WARNINGS.find(recipient: params[:username]).sort('issuedAt', 'descending')
      haml :player_info, layout: false, locals: {bp_player: bp_player, ct_player: ct_player, sessions: sessions, warnings: warnings}
    else
      haml :record_not_found, layout: false
    end
  else
    haml :form_incomplete, layout: false
  end
 end

get '/block_history' do
  haml :block_history
end

get '/block_events' do
  if block_event_params_exist?(params)
    block_events = BP_BLOCK_EVENTS.find(b: {x: Integer(params[:x]), y: Integer(params[:y]), z: Integer(params[:z])}, w: params[:world])
    haml :block_events, layout: false, locals: {block_events: block_events}
  else
    haml :form_incomplete, layout: false
  end
end

private

def block_event_params_exist?(params)
  return true if exists?(params[:x]) && exists?(params[:y]) && exists?(params[:z]) && exists?(params[:world])
  false
end

def exists?(param)
  (param && param != "") ? true : false
end