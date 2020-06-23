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

# pokemons = catch_all_og_pokemon

# pokemons.each.with_index do |poke_hash, index|
#   response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{poke_hash[:name]}")
#   data = response.parsed_response
#   base_exp = data["base_experience"]
#   weight = data["weight"]
#   type1 = data["types"][0]["type"]["name"]
#   if data["types"][1]
#     type2 = data["types"][1]["type"]["name"]
#   else
#     type2 = "none"
#   end

#   # name = data_csv[0]['identifier'] #=> bulbasaur
#   evolution_chain_id = $species_csv[index]['evolution_chain_id'] #=> bulbasaur
#   evolution = 


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


evolution_chain_id = $species_csv[130]['evolution_chain_id'] #=> bulbasaur
puts evolution_chain_id


def get_all_evolutions(id)
  # id = id.to_i
  puts id
  arr = []
  $species_csv.each do |poke|
    puts poke['identifier']

    # break if poke['evolution_chain_id'] > id
    arr.push(poke['identifier']) if id == poke['evolution_chain_id']
  end
  return arr
end


puts get_all_evolutions(evolution_chain_id)

# def get_all_evolutions(url)
#   arr = []
#   evolution_chain = HTTParty.get(url)
#   evolution_chain = evolution_chain.parsed_response

#   base_form = evolution_chain["chain"]["species"]["name"].capitalize #Bulbasaur / #Eevee
#   arr.push(base_form)
#   return arr if evolves?(evolution_chain["chain"]) == false

#   if base_form.downcase == "eevee"
#     alt_evo0 = evolution_chain["chain"]["evolves_to"][0]["species"]["name"].capitalize #Vaporeon
#     alt_evo1 = evolution_chain["chain"]["evolves_to"][1]["species"]["name"].capitalize #Jolteon
#     alt_evo2 = evolution_chain["chain"]["evolves_to"][2]["species"]["name"].capitalize #Flareon
#     arr.push(alt_evo0, alt_evo1, alt_evo2)
#     return arr
#   end

#   second_form = evolution_chain["chain"]["evolves_to"][0]["species"]["name"].capitalize #Ivysaur
#   arr.push(second_form)
#   return arr if evolves?(evolution_chain["chain"]["evolves_to"][0]) == false

#   third_form = evolution_chain["chain"]["evolves_to"][0]["evolves_to"][0]["species"]["name"].capitalize #Venusaur
#   arr.push(third_form)

#   return arr #array of strings

# end


