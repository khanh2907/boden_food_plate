Rails.application.routes.draw do
  resources :food_diaries

  get 'food_diaries/:id/:day' => 'food_diaries#day', :as => 'fd_day'
  post 'food_diaries/:id/:day' => 'food_diaries#next_day', :as => 'next_day'
  get 'breakdown/:id/' => 'food_diaries#breakdown', :as => 'food_diary_breakdown'

  get 'search_category/:id' => 'food_diaries#search_category', :as => 'search_category'

  get 'search/index'
  get 'search/query'
  get 'search/query_participant'
  get 'search/check_participant' => 'search#check_participant'

  root to: 'food_diaries#index'
  devise_for :users
  resources :users

  get '/foods' => 'food_categories#index', :as => 'food_categories'
  get '/categories/:id' => 'food_categories#show', :as => 'food_category'
end


