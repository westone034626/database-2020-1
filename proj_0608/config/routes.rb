Rails.application.routes.draw do
  root 'reads#index'
  get '/books/new' => 'books#new'
  post '/books/search' => 'books#search'
  post '/books/create' => 'books#create'
  get '/reads/delete/:book_id' => 'reads#delete'
  get '/reads/create/:book_id' => 'reads#create'
  get '/reads/clear/:book_id' => 'reads#clear'
  get '/reads/show_complete_books' => 'reads#show_complete_books'
  get '/users/index/:ord' => 'users#index'
  get '/users/create/:user_id' => 'users#create'
  get '/users/delete' => 'users#delete'
  get '/users/show' => 'users#show'
  get '/users/show_mentor_books/:user_id' => 'users#show_mentor_books'
  get '/users/show_mentor_mentees/:user_id' => 'users#show_mentor_mentees'
  get '/users/show_mentees' => 'users#show_mentees'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
