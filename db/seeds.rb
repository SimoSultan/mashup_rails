# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'httparty'
require 'csv'
require 'json'

$species_csv = CSV.parse(File.read('../lib/assets/pokemon_species.csv'), headers: true)
$pokemons_csv = CSV.parse(File.read('../lib/assets/pokemon.csv'), headers: true)
$description_csv = CSV.parse(File.read('../lib/assets/pokemon_species_flavor_text.csv'), headers: true)
 


# home page
def catch_all_og_pokemon
  response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=151")
  data = response.parsed_response["results"]
  
  min_data = []
  data.each do |h|
    id = h["url"].scan(/\/\d{1,3}\//).first
    id = id[1..-2]
    name = h["name"]
    url = h["url"]
    image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{id}.png"
    new_h = {name: name, num: id, image: image, url: url}
    min_data.push(new_h)
  end
  min_data
end

def extract_description #returns an array of description; one for each pokemon
  arr_of_description = Array.new
  counter = 1
  $description_csv.each do |poke_info|
  if poke_info['species_id'].to_i == counter
    arr_of_description.push(poke_info['flavor_text'])
    counter += 1
  end
  end
  arr_of_description
end

pokemons = catch_all_og_pokemon
description = extract_description

pokemons = pokemons.each_with_index do |pokemon, i|
  pokemon[:weight] = $pokemons_csv[i]['weight']
  pokemon[:base_exp] = $pokemons_csv[i]['base_experience']
  pokemon[:description] = description[i]
end


#   Pokemon.create(name: poke_hash[:name], image: poke_hash[:image], base_exp: base_exp, weight: weight, type1: type1, type2: type2, )
# end


#show
def get_poke_deets(name)
  # poke_deets_arr = Array.new
  # pokemon_name = params["name"].downcase
  # response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{name}")
  # data = response.parsed_response
  # name = pokemon_name.capitalize
  # num = data["id"]
  # base_exp = data["base_experience"]

  # weight = data["weight"]

  image = "https://pokeres.bastionbot.org/images/pokemon/#{num}.png"
  # abilities = data["abilities"]
  # type1 = data["types"][0]["type"]["name"].capitalize
  # if data["types"][1]
  #   type2 = data["types"][1]["type"]["name"].capitalize
  # else
  #   type2 = "None"
  # end
  # poke_deets_arr.push(base_exp, weight, type1, type2)

  # return poke_deets_arr
end