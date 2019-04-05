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
  single_station_data(terminal_id).to_json
end

get '/stations/:terminal_ids/:query' do |terminal_ids, query|
  halt 404 unless ['bikes', 'docks'].include? query
  stations = multiple_station_data(terminal_ids)
  output = {
    "available_#{query}_hash" => {},
    "available_#{query}_array" => []
  }
  stations.each do |station|
    terminal_id = station['properties']['station']['terminal']
    quantity = station['properties']['station']["#{query}_available"]
    output["available_#{query}_hash"][terminal_id] = quantity
    output["available_#{query}_array"] << quantity
  end
  output.to_json
end
