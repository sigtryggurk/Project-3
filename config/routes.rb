SigtryggProj3::Application.routes.draw do
  get "errors/bad_route"

  resource :stickies
  resource :sessions
  resource :users

  post "create_sticky" => "stickies#create_sticky"
  post "update_sticky" => "stickies#update_sticky"
  post "delete_sticky" => "stickies#delete_sticky"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "create_stickies" => "stickies#create"  
 
  root :to => 'home#index'

  match '*a', :to => 'errors#invalid_route'
end
