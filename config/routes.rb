Rails.application.routes.draw do
  resources :games do
    resources :rounds do
      post :activate, on: :member
      post :deactivate, on: :member
      post :complete, on: :member
      post :continue, on: :member
      get "answers", on: :member
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
