require 'test_helper'

class PokemonsControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pokemons_home_url
    assert_response :success
  end

end
