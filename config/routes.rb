Rails.application.routes.draw do
  resources :leitner_card_boxes
  resources :cards
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "cards#index"
end
