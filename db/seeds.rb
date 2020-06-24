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

#reads csv files to be stored in the database
$pokemons_csv = CSV.parse(File.read(Rails.root.join('lib','assets','pokemon.csv')), headers: true)
$species_csv = CSV.parse(File.read(Rails.root.join('lib','assets','pokemon_species.csv')), headers: true)
$description_csv = CSV.parse(File.read(Rails.root.join('lib','assets','pokemon_species_flavor_text.csv')), headers: true)
$types_csv = CSV.parse(File.read(Rails.root.join('lib','assets','types.csv')), headers: true)
$poke_types = CSV.parse(File.read(Rails.root.join('lib','assets','pokemon_types.csv')), headers: true)
 


# home page; submits a get request from the pokeAPI.
# Pokemon details returned would then be stored in the DB.
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

# Extracts description of a pokemon from the csv file and
#returns an array of description; one for each pokemon
def extract_description
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

# Extracts types of the pokemon from the csv file and
#returns an array that has an array of the types of the pokemon
# if the pokemon has only one type, a default value of 'none'
# would be its type2
def extract_types
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

# Gets the evelution chain of the pokemon from the csv file
# then returns it as an array
def get_all_evolutions(id)
  arr = []
  $species_csv.each do |poke|
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
