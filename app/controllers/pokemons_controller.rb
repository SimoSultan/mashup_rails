

class PokemonsController < ApplicationController


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

    #for user
    if session[:users].nil?
      session[:users] = Hash.new
      session[:passwords] = Hash.new
    else
      # @user = {params[:name] => params[:user][:email]}
      @user = session[:current_user]
    end
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

  def sign_in
    
  end
  
  def signed_in
    if session[:users].has_value?(params[:user][:email])
      user_email = params[:user][:email]
      user_password = params[:password]
      if session[:passwords][user_email] == user_password
        user_name = session[:users].key(user_email)
        session[:current_user] = {user_name => user_email}
        redirect_to pokemons_home_path
      else
        redirect_to pokemons_sign_in_path
      end
      
    else
      redirect_to pokemons_sign_in_path
    end
  end

  def sign_up

  end

  def signed_up
    session[:users][params[:name]] = params[:user][:email]
    session[:passwords][params[:user][:email]] = params[:password]
    # session[:name].push(params[:name])
    # session[:email].push(params[:user][:email])
    # @user = {params[:name] => params[:user][:email]}
    session[:current_user] = {params[:name] => params[:user][:email]}
    redirect_to pokemons_home_path
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

end
