Rails.application.routes.draw do
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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "cards#index"
end
