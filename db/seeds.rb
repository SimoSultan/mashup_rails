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

$pokemons_csv = CSV.parse(File.read('../lib/assets/pokemon.csv'), headers: true)
$species_csv = CSV.parse(File.read('../lib/assets/pokemon_species.csv'), headers: true)
$description_csv = CSV.parse(File.read('../lib/assets/pokemon_species_flavor_text.csv'), headers: true)
$types_csv = CSV.parse(File.read('../lib/assets/types.csv'), headers: true)
$poke_types = CSV.parse(File.read('../lib/assets/pokemon_types.csv'), headers: true)
 


# home page
def catch_all_og_pokemon
  response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=151")
  data = response.parsed_response["results"]
  
  min_data = []
  data.each.with_index do |h,i|
    id = h["url"].scan(/\/\d{1,3}\//).first
    id = id[1..-2]
    name = h["name"]
    url = h["url"]
    image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{id}.png"
    evolution_chain_id = $species_csv[i]['evolution_chain_id'] #=> bulbasaur
    evolutions = get_all_evolutions(evolution_chain_id)

    new_h = {name: name, num: id, image: image, url: url, evolutions: evolutions}
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

def extract_types #returns an array that has an array of types; one for each pokemon
  types_hash = Hash.new
  $types_csv.each do |type|
    types_hash[type['id']] = type['identifier']
  end
  
  array_of_types = Array.new
  #Each element in the array can be another array of types, depending on the pokemon.
  #index 0 will be for bulbasaur and so forth.
  counter = 1
  array_of_subtype = Array.new
  $poke_types.each do |type|
    if counter == type['pokemon_id'].to_i
      array_of_subtype.push(types_hash[type['type_id']])
    else
      array_of_types.push(array_of_subtype)
      array_of_subtype = Array.new
      array_of_subtype.push(types_hash[type['type_id']])
      counter += 1
    end
  end

  array_of_types.each{|arr| arr.push("none") if arr.length == 1}
end


def get_all_evolutions(id)
  arr = []
  $species_csv.each do |poke|
    # break if poke['evolution_chain_id'] > id
    arr.push(poke['identifier']) if id == poke['evolution_chain_id']
  end
  return arr
end


pokemons = catch_all_og_pokemon()
description = extract_description()
types = extract_types()



# BUILD POKEMON DATABASE


pokemons = pokemons.each_with_index do |pokemon, i|
  pokemon[:weight] = $pokemons_csv[i]['weight']
  pokemon[:base_exp] = $pokemons_csv[i]['base_experience']
  pokemon[:description] = description[i]
  pokemon[:type1] = types[i].first
  pokemon[:type2] = types[i].last

  Pokemon.create(name: pokemon[:name], image: pokemon[:image], base_exp: pokemon[:base_exp], weight: pokemon[:weight], type1: pokemon[:type1], type2: pokemon[:type2], description: pokemon[:description], evolutions: pokemon[:evolutions] )
end


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