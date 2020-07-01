class PokemonsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :setup_party

  def home
    # get all the pokemon from the database
    @all_pokemon = Pokemon.all

    # if someone has searched for a pokemon
    # then search through list
    if !params['pokemon_name'].nil?
      @search_pokemon = Array.new
      @all_pokemon.each do |pokemon|
        if pokemon[:name].include?(params['pokemon_name'])
          @search_pokemon.push(pokemon)
        end
      end

      return @search_pokemon.empty? ? @all_pokemon : (@all_pokemon = @search_pokemon)
    end
  end


  def party
    @party = []
    session[:party].each do |name_str|
      pokemon = Pokemon.find_by_name(name_str)
      @party.push(pokemon)
    end
    @party
  end

  def add_to_party

    if session[:party].length >= 6
      flash.alert = "Your party already contains 6 pokemon. You cannot add more."
    end

    session[:party].push(params[:name])
    puts "added #{params[:name]} to party"
  end

  def show_party_remove_modal
    respond_to do |format|
      format.js { render :partial => '../javascript/party/remove.js.erb' }
    end
    @pokemon_name = params[:name]

  end

  def remove_from_party
    session[:party].delete(params[:name]) 
    puts "removed #{params[:name]} from party"
    party()
    render 'party'
  end


  def show
    # get the requested pokemon information from database for show page
    @pokemon = Pokemon.find_by_name(params[:name])
    # if the pokemon has more than itself in the array of string in evolutions
    # then turn the string into an object received from the DB
    if @pokemon[:evolutions].length > 1
      @pokemon[:evolutions].each.with_index do |poke_name, i|
        @pokemon[:evolutions][i] = Pokemon.find_by_name(poke_name)
      end
    end
    
    # sets the type as the key and colour as the value
    @pokemon_type1_colour = type_colour(@pokemon[:type1])
    @pokemon_type2_colour = type_colour(@pokemon[:type2])
  end





  def reset_session
    session.clear
    puts "session = #{session[:party]}"
  end

  def log_session
    puts "session = #{session[:party]}"
  end



  private 

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
        return {type.downcase => colour_scheme[type.downcase]}
      else
        return {type.downcase => 'lightgray'}
      end

    end

    def setup_party
      # session.clear
      if session[:party] == nil
        session[:party] = []
      end
    end

end
