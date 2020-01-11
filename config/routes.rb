Rails.application.routes.draw do
  root 'users#index'
  get 'my' => 'users#index' 
  post 'signin' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  post 'signup' => 'users#create'
  
  resources :users, only: [:index, :update, :create, :show] do
    member do
      post :update
      get :show
    end
  end
end
