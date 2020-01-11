Rails.application.routes.draw do
  root 'users#index'
  get 'my' => 'users#index' 
  post 'signin' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  post 'signup' => 'users#create'
  
  resources :users, only: [:index, :update, :create, :show, :body_sizing] do
    member do
      patch :update
      get :show
      post :body_sizing 
    end
  end
end
