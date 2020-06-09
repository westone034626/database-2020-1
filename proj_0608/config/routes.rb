Rails.application.routes.draw do
  root 'reads#index'
  get '/books/new' => 'books#new'
  post '/books/create/' => 'books#create'
  get '/reads/delete/:book_id' => 'reads#delete'
  get '/reads/create/:book_id' => 'reads#create'

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
