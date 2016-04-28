Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end

  root "events#index"

  resources :conferences, only: [:index, :edit, :update]

  resources :events do
    member do
      post :list
    end

    resources :comments, only: [:create]
  end

  resources :users, only: [:index] do
    collection do
      get :me
      put :me, action: :update_me
    end

    member do
      post "promote/:role", action: :promote, as: :promote
    end
  end
end
