Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end

  root "events#index"
  resources :events, only: [:create, :index, :new]
end
