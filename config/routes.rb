Rails.application.routes.draw do

  get 'guide' => 'visitors#guide', :as => 'guide'
  get 'manage' => 'food_diaries#set_management', :as => 'set_management'

  get 'food_diaries/export_study/:study_name' => 'food_diaries#export_study', :as => 'export_study'
  post 'food_diaries/delete_selected' => 'food_diaries#delete_selected', :as => 'fd_delete_selected'
  get 'food_diaries/delete_study' => 'food_diaries#delete_study', :as => 'delete_study'
  resources :food_diaries
  get 'food_diaries/:id/:day' => 'food_diaries#day', :as => 'fd_day'
  post 'food_diaries/:id/:day' => 'food_diaries#next_day', :as => 'next_day'
  get 'breakdown/:id/' => 'food_diaries#breakdown', :as => 'food_diary_breakdown'

  devise_for :participants, :except => [:registration]
  resources :participants
  get 'participants/:id/resend_invite' => 'participants#resend_invite', :as => 'participant_resend_invite'

  get 'search_all' => 'search#search_all', :as => 'search_all'
  get 'search_category/:id' => 'search#search_category', :as => 'search_category'

  get 'search/check_participant' => 'search#check_participant'

  devise_for :users
  resources :users

  get '/foods' => 'food_categories#index', :as => 'food_categories'
  get '/categories/:id' => 'food_categories#show', :as => 'food_category'

  root to: 'visitors#index'

  get 'dashboard' => 'participants_mode/general#index', :as => 'participants_mode_dashboard'

  get 'food_diary/:id/:day' => 'participants_mode/food_diaries#day', :as => 'participants_mode_fd_day'
  post 'food_diary/:id/:day' => 'participants_mode/food_diaries#next_day', :as => 'participants_mode_next_day'
  get 'fbreakdown/:id/' => 'participants_mode/food_diaries#breakdown', :as => 'participants_mode_food_diary_breakdown'

end


