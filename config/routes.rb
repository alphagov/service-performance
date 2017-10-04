Rails.application.routes.draw do
  namespace :admin do
    resources :metrics, controller: 'monthly_service_metrics', only: [:index, :show]
    resources :delivery_organisations
    resources :services
    resources :users

    root to: "services#index"
  end

  resources :services, only: [] do
    constraints year: /\d{4}/, month: /\d{2}/ do
      get 'metrics/:year/:month(/:publish_token)', to: 'monthly_service_metrics#edit', as: :metrics
      patch 'metrics/:year/:month(/:publish_token)', to: 'monthly_service_metrics#update'
    end
  end

  devise_for :users
  root 'pages#homepage'
end
