Rails.application.routes.draw do
  namespace :admin do
    resources :services
    resources :users

    root to: "services#index"
  end

  devise_for :users
  root 'pages#homepage'

end
