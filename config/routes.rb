Codemav::Application.routes.draw do

  devise_for :users do
    get "confirmation", :to => "devise/users#confirmation"
    get "login", :to => "devise/sessions#new"
    get 'logout', :to => "devise/sessions#destroy"
  end
  
  resources :profiles
  resources :stack_overflow_profiles
  resources :speaker_rate_profiles
  resources :git_hub_profiles do
    collection do
      get "synch"
    end
  end
  
  resources :people_searches
  
  namespace :api do
    resources :profiles
  end
  
  root :to => "pages#home"
  
end
