Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # LANDING PAGE
  root "landings#index"

  # CELEBRITIES
  # root "celebrities#home"
  # root "/" to:"celebrities#home"
  get "/celebrities", to: "celebrities#home", as:"celebrities_home"
  get "/celebrities/show", to: "celebrities#show", as:"show"
  post "/celebrities/create", to: "celebrities#create", as:"create"
  put "/celebrities/update", to: "celebrities#update", as:"update"
  delete "/celebrities/destroy", to: "celebrities#destroy", as:"destroy"

  # BOOKS
  get "/books", to: "books#home", as:"books_home"
  get "/books/show", to: "books#show", as:"books_show"
  # post "/books/create", to: "books#create", as:"books_create"
  # post "/books/create/:id", to: "books#create"
  get "/books/about", to: "books#about", as:"books_about"

  # PRODUCTS
  get "/products", to: "products#home", as:"products_home"

  # PHOTOS
  get 'photos/home', to: "photos#home", as: "photos_home"

  # POKEMON
  get '/pokemons', to: "pokemons#home", as: "pokemons_home"
  get 'pokemons/:name', to: "pokemons#show", as:"pokemons_show"
  # get 'pokemons/party', to: "pokemons#party", as: "pokemons_party"
  # post 'pokemons/add', to: "pokemons#add", as: "pokemons_party_add"
  # delete 'pokemons/remove', to: "pokemons#remove", as: "pokemons_party_remove"
end
