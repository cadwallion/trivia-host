Rails.application.routes.draw do
  resources :games do
    resources :rounds do
      get "answers", on: :member
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
