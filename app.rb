require 'sinatra'
require 'json'
require 'open-uri'

def fetch_station(id)
  url = 'https://layer.bicyclesharing.net/map/v1/mtl/map-inventory'
  response_serialized = open(url).read
  stations = JSON.parse(response_serialized)["features"]
  station_index = stations.find_index { |elt| elt["properties"]["station"]["id"] == id }
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
  num_bikes = station["properties"]["station"]["bikes_available"]
  { bike_qty: num_bikes }.to_json
end

get '/stations/:id/docks' do |id|
  station = fetch_station(id)
  num_docks = station["properties"]["station"]["docks_available"]
  { dock_qty: num_docks }.to_json
end
