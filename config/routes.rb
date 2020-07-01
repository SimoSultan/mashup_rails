Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # LANDING PAGE
  root "landings#index"


  # CELEBRITIES
  get "/celebrities", to: "celebrities#home", as:"celebrities_home"
  get "/celebrities/show", to: "celebrities#show", as:"show"
  post "/celebrities/create", to: "celebrities#create", as:"create"
  put "/celebrities/update", to: "celebrities#update", as:"update"
  delete "/celebrities/destroy", to: "celebrities#destroy", as:"destroy"


  # BOOKS
  get "/books", to: "books#home", as:"books_home"
  get "/books/show", to: "books#show", as:"books_show"
  get "/books/about", to: "books#about", as:"books_about"


  # PRODUCTS
  get "/products", to: "products#home", as:"products_home"


  # PHOTOS
  get '/photos/home', to: "photos#home", as: "photos_home"


  # POKEMON
  get '/pokemons', to: "pokemons#home", as: "pokemons_home"
  get '/pokemons/party', to: "pokemons#party", as: "pokemons_party"
  get '/pokemons/:name', to: "pokemons#show", as:"pokemons_show"
  get '/pokemons/remove/:name', to: "pokemons#show_party_remove_modal", as:"pokemons_party_remove_modal"

  post '/pokemons/reset', to: "pokemons#reset_session", as:"pokemons_reset_session"
  post '/pokemons/log', to: "pokemons#log_session", as:"pokemons_log_session"
  post '/pokemons/:name', to: "pokemons#add_to_party", as: "pokemons_party_add"
  delete '/pokemons/:name', to: "pokemons#remove_from_party", as: "pokemons_party_remove"


  # SCHOOLS
  get "/schools", to: "schools#index", as: "schools_index"

  get "/schools/students", to: "schools#students", as: "schools_students"
  get "/schools/students/edit/:id", to: "schools#student_edit", as: "schools_student_edit"
  patch "/schools/students/:id", to: "schools#student_update", as: "schools_student_update"
  get "/schools/students/new", to: "schools#student_new", as: "schools_student_new"
  post "/schools/students/new", to: "schools#student_create", as: "schools_student_create"
  delete "/schools/students/:id", to: "schools#student_destroy", as: "schools_student_destroy"
  
  get "/schools/teachers", to: "schools#teachers", as: "schools_teachers"
  get "/schools/teachers/edit/:id", to: "schools#teacher_edit", as: "schools_teacher_edit"
  patch "/schools/teachers/:id", to: "schools#teacher_update", as: "schools_teacher_update"
  get "/schools/teachers/new", to: "schools#teacher_new", as: "schools_teacher_new"
  post "/schools/teachers/new", to: "schools#teacher_create", as: "schools_teacher_create"
  delete "/schools/teachers/:id", to: "schools#teacher_destroy", as: "schools_teacher_destroy"

  get "/schools/subjects", to: "schools#subjects", as: "schools_subjects"
  get "/schools/subjects/edit/:id", to: "schools#subject_edit", as: "schools_subject_edit"
  patch "/schools/subjects/:id", to: "schools#subject_update", as: "schools_subject_update"
  get "/schools/subjects/new", to: "schools#subject_new", as: "schools_subject_new"
  post "/schools/subjects/new", to: "schools#subject_create", as: "schools_subject_create"
  delete "/schools/subjects/:id", to: "schools#subject_destroy", as: "schools_subject_destroy"


end
