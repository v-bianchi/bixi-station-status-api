require 'sinatra'
require 'json'
require 'open-uri'

URL = 'https://layer.bicyclesharing.net/map/v1/mtl/map-inventory'

def fetch_json
  response_serialized = open(URL).read
  JSON.parse(response_serialized)['features']
end

def single_station_data(terminal_id)
  all_stations = fetch_json
  all_stations.find { |station| station['properties']['station']['terminal'] == terminal_id }
end

def multiple_station_data(terminal_ids)
  all_stations = fetch_json
  # If user inputs many `-`, as in `---5-4---2-3-`, it could result in empty string elements
  terminal_id_array = terminal_ids.split('-').reject { |elt| elt == '' }
  # Return array of selected stations
  terminal_id_array.map do |terminal_id|
    all_stations.find { |station| station['properties']['station']['terminal'] == terminal_id }
  end
end


get '/' do
  erb :index
end

get '/stations/:terminal_id' do |terminal_id|
  JSON.pretty_generate(single_station_data(terminal_id))
end

get '/stations/:terminal_ids/bikes' do |terminal_ids|
  stations = multiple_station_data(terminal_ids)
  stations_bikes_only = {}
  stations_bikes_only['bikes_available'] = stations.map do |station|
    { station['properties']['station']['terminal'] => station['properties']['station']['bikes_available'] }
  end
  JSON.pretty_generate(stations_bikes_only)
end

get '/stations/:terminal_ids/docks' do |terminal_ids|
  stations = multiple_station_data(terminal_ids)
  stations_bikes_only = {}
  stations_bikes_only['docks_available'] = stations.map do |station|
    { station['properties']['station']['terminal'] => station['properties']['station']['docks_available'] }
  end
  JSON.pretty_generate(stations_bikes_only)
end
