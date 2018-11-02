require 'sinatra'
require 'json'
require 'open-uri'

def fetch_station(id)
  url = 'https://api-core.bixi.com/gbfs/en/station_status.json'
  response_serialized = open(url).read
  stations = JSON.parse(response_serialized)["data"]["stations"]
  station_index = stations.find_index { |elt| elt["station_id"] == id }
  return stations[station_index]
end

get '/' do
  erb :index
end

get '/stations/:id' do |id|
  fetch_station(id).to_json
end

get '/stations/:id/bikes' do |id|
  station = fetch_station(id)
  num_bikes = station["num_bikes_available"] + station["num_ebikes_available"]
  { bike_qty: num_bikes }.to_json
end

get '/stations/:id/docks' do |id|
  station = fetch_station(id)
  num_docks = station["num_docks_available"]
  { dock_qty: num_docks }.to_json
end
