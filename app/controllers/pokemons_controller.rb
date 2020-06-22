# require 'net/http'
# require 'json'
# require 'poke-api-v2'
require 'httparty'

class PokemonsController < ApplicationController

  before_action :catch_all_og_pokemon
  @@pokemons = []

  def home
    @all_pokemon = @@pokemons

    @all_pokemon.each do |pokemon|
      if pokemon[:name] == params['pokemon_name']
        @all_pokemon = [pokemon]
      end
    end
    @all_pokemon
  end

  def show
    pokemon_name = params["name"].downcase
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{pokemon_name}")
    data = response.parsed_response
    name = pokemon_name.capitalize
    num = data["id"]
    base_exp = data["base_experience"]
    weight = data["weight"]
    image = "https://pokeres.bastionbot.org/images/pokemon/#{num}.png"
    abilities = data["abilities"]
    type1 = data["types"][0]["type"]["name"].capitalize
    if data["types"][1]
      type2 = data["types"][1]["type"]["name"].capitalize
    else
      type2 = "None"
    end
    
    species = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon_name}")
    species = species.parsed_response
    description = species["flavor_text_entries"][0]["flavor_text"]

    evolution_chain_url = species["evolution_chain"]["url"]
    evolutions = get_all_evolutions(evolution_chain_url) #=> an array of strings

    evolutions = check_if_pokemon_are_all_in_original(evolutions) #=> an array of hashes of basic pokemon info 

    type1 = type_colour(type1)
    type2 = type_colour(type2)

    @pokemon = {
      name: name, 
      num: 1, 
      image: image, 
      description: description, 
      type1: type1, 
      type2: type2, 
      weight: weight, 
      base_exp: base_exp,
      evolutions: evolutions,
    }
  end


  private 

    def catch_all_og_pokemon
      response = HTTParty.get("https://pokeapi.co/api/v2/pokemon?limit=151")
      data = response.parsed_response["results"]
      @@pokemons = []
      
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
      @@pokemons = min_data
    end


    def get_all_evolutions(url)
      arr = []
      evolution_chain = HTTParty.get(url)
      evolution_chain = evolution_chain.parsed_response

      base_form = evolution_chain["chain"]["species"]["name"].capitalize #Bulbasaur / #Eevee
      arr.push(base_form)
      return arr if evolves?(evolution_chain["chain"]) == false
    
      if base_form.downcase == "eevee"
        alt_evo0 = evolution_chain["chain"]["evolves_to"][0]["species"]["name"].capitalize #Vaporeon
        alt_evo1 = evolution_chain["chain"]["evolves_to"][1]["species"]["name"].capitalize #Jolteon
        alt_evo2 = evolution_chain["chain"]["evolves_to"][2]["species"]["name"].capitalize #Flareon
        arr.push(alt_evo0, alt_evo1, alt_evo2)
        return arr
      end

      second_form = evolution_chain["chain"]["evolves_to"][0]["species"]["name"].capitalize #Ivysaur
      arr.push(second_form)
      return arr if evolves?(evolution_chain["chain"]["evolves_to"][0]) == false

      third_form = evolution_chain["chain"]["evolves_to"][0]["evolves_to"][0]["species"]["name"].capitalize #Venusaur
      arr.push(third_form)

      return arr #array of strings

    end

  
    def evolves?(form) #evolution_chain["chain"]
      form["evolves_to"].empty? ? false : true
    end
    
    # def is_eevee?(base_form)
    #   @@pokemons.any? {|h| h[:name] == base_form.downcase} ? true : false
    # end


    def check_if_pokemon_are_all_in_original(pokemon_arr)
      new_arr = []
      pokemon_arr.each do |pok|
        @@pokemons.any? do |h| 
          if h[:name] == pok.downcase
            new_arr.push(h) 
          end
        end
      end
      return new_arr
    end

    # def is_baby? #future
    # end


    def type_colour(type)
      colour_scheme = {
        'fire' => '#F08030',
        'grass' => '#78C850',
        'electric' => '#F8D030',
        'water' => '#6890F0',
        'poison' => '#A040A0',
        'ground' => '#E0C068',
        'psychic' => '#F85888',
        'bug' => '#A8B820',
        'normal' => '#A8A878',
        'flying' => '#A890F0',
        'dragon' => '#7038F8',
        'ice' => 	'#98D8D8',
        'dark' => '#705848',
        'fairy' => '#EE99AC',
        'fighting' => '#C03028',
        'ghost' => '#705898',
        'rock' => '#B8A038',
        'steel' => '#B8B8D0'
      }
      
      if colour_scheme.has_key?(type.downcase)
        return {type => colour_scheme[type.downcase]}
      else
        return {type => 'lightgray'}
      end
    end

end
