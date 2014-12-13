Rails.application.routes.draw do
  resources :food_diaries

  get 'food_diaries/:id/:day' => 'food_diaries#day'

  get 'search/index'
  get 'search/query'
  get 'search/query_participant'
  get 'search/check_participant' => 'search#check_participant'

  root to: 'visitors#index'
  devise_for :users
  resources :users

  get '/foods' => 'food_categories#index', :as => 'food_categories'
  get '/categories/:id' => 'food_categories#show', :as => 'food_category'
end


