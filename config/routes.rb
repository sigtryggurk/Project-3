SigtryggProj3::Application.routes.draw do
  resource :stickies
  resource :sessions
  resource :users

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "create_stickies" => "stickies#create"  
 
  root :to => 'home#index'

end
