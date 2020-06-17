# require 'net/http'
# require 'json'
# require 'poke-api-v2'
require 'httparty'

class PokemonsController < ApplicationController

  before_action :catch_all_og_pokemon
  @@pokemons = []

  def home
    @all_pokemon = @@pokemons
  end

  def show
    pokemon_name = params["name"].downcase
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{pokemon_name}")
    data = response.parsed_response
    name = pokemon_name.capitalize
    num = data["id"]
    base_exp = data["base_experience"]
    weight = data["weight"]
    # image = data["sprites"]["front_default"]
    image = "https://pokeres.bastionbot.org/images/pokemon/#{num}.png"
    abilities = data["abilities"]
    type1 = data["types"][0]["type"]["name"].capitalize
    if data["types"][1]
      type2 = data["types"][1]["type"]["name"].capitalize
    else
      type2 = "None"
    end
    
    species = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon_name}")
    parsed_species = species.parsed_response
    description = parsed_species["flavor_text_entries"][0]["flavor_text"]

    @pokemon = {name: name, num: 1, image: image, description: description, type1: type1, type2: type2, weight: weight, base_exp: base_exp}
  end

  private def catch_all_og_pokemon
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=151")
    data = response.parsed_response["results"]
    # puts data[0]["name"]
    @@pokemons = []
    # @@pokemons = data
    
    min_data = []
    data.each do |h|
      id = h["url"].scan( /\/[0-9]{1,3}\// ).first
      id = id[1..-2]
      name = h["name"]
      image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{id}.png"
      new_h = {name: name, num: id, image: image}
      min_data.push(new_h)
    end
    @@pokemons = min_data



    # response = PokeApi.get(pokemon: 'bulbasaur')
    # puts response
    # image = response.sprites.front_default
    # text_response = PokeApi.get(pokemon_species: 'rapidash').flavor_text_entries.find do |text|
    #   { 
    #     if text.language.name == "en"
    #    text.flavor_text
    #   }
    # puts text_response
    # name = response.name.capitalize
    # name = response.name
    # num = response.id
    # puts response[:types]
    # type1 = response["types"][0]
    # type1 = response.types[0][:type][:name]
    # type2 = response.types[1][:type][:name]
    # type2 = response["types"][0]
    # image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{num}.png"
    # @@pokemons.push({name: name, num: num, image: image}) 
    # @@pokemons.push({name: name, num: num, image: image, type1: type1, type2: type2}) 
  end

  def catch_one_og_pokemon()
    pokemon = "bulbasaur"
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{pokemon}")
    @@pokemons = []
    data = response.parsed_response
    name = data["name"].capitalize
    num = data["id"]
    base_exp = data["base_experience"]
    weight = data["weight"]
    image = data["sprites"]["front_default"]
    # image = "https://pokeres.bastionbot.org/images/pokemon/#{num}.png"

    abilities = data["abilities"]
    type1 = data["types"][0]["type"]["name"]
    type2 = data["types"][1]["type"]["name"]

    species = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon}")
    parsed_species = species.parsed_response
    description = parsed_species["flavor_text_entries"][0]["flavor_text"]

    # @@pokemons.push({name: name, num: 1, image: image, description: "I like grass", type1: type1, type2: type2}) 
    @@pokemons.push({name: name, num: 1, image: image, description: description, type1: type1, type2: type2}) 

  end
end
