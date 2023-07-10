Rails.application.routes.draw do

  root "cards#learn"
  
  resources :leitner_card_boxes
  resources :cards do
    collection do
      get :learn
      post :import
    end
    member do
      post :remember
      post :forget
    end
  end
  
  devise_for :users
  get 'memory_systems', to: 'memory_systems#index'
  get '/api/gpt/:message', to: 'api#gpt'
end
