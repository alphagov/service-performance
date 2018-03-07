Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  get "/demo", to: "demo#index"

  namespace :publish, path: 'publish', module: nil do
    get "/service-manual", to: "publish_data/pages#service_manual"

    resources :services, only: [] do
      constraints year: /\d{4}/, month: /\d{2}/ do
        get 'metrics/:year/:month(/:publish_token)', to: 'publish_data/monthly_service_metrics#edit', as: :metrics
        get 'metrics/:year/:month(/:publish_token)/preview', to: 'publish_data/monthly_service_metrics#preview', as: :preview_metrics
        patch 'metrics/:year/:month(/:publish_token)', to: 'publish_data/monthly_service_metrics#update'
      end
    end

    devise_for :users
  end

  namespace :view_data, path: nil, module: nil do
    root 'view_data/pages#homepage'
    get "/how-to-use", to: "view_data/pages#how_to_use"
    get "/help/transactions-received", to: "view_data/pages#transactions_received_help"
    get "/help/transactions-processed", to: "view_data/pages#transactions_processed_help"
    get "/help/calls-received", to: "view_data/pages#calls_received_help"

    get "/help/cookies", to: "view_data/pages#cookies"
    get "/help/terms-conditions", to: "view_data/pages#terms"
    get "/help/privacy-policy", to: "view_data/pages#privacy"

    scope 'performance-data' do
      scope :government do
        get 'metrics/:group_by', to: 'view_data/government_metrics#index',
          group_by: Regexp.union(Metrics::GroupBy::Department, Metrics::GroupBy::DeliveryOrganisation, Metrics::GroupBy::Service),
          defaults: { group_by: Metrics::GroupBy::Department },
          as: :government_metrics
        get 'missing', to: 'view_data/government#missing'
        get '', to: 'view_data/government#show'
      end

      resources :departments, only: [] do
        get 'metrics/:group_by', to: 'view_data/department_metrics#index',
          group_by: Regexp.union(Metrics::GroupBy::DeliveryOrganisation, Metrics::GroupBy::Service),
          defaults: { group_by: Metrics::GroupBy::DeliveryOrganisation },
          as: :metrics
        get 'missing', to: 'view_data/departments#missing'
      end

      resources :delivery_organisations, only: [] do
        get 'metrics/:group_by', to: 'view_data/delivery_organisation_metrics#index', group_by: Metrics::GroupBy::Service, as: :metrics
        get 'missing', to: 'view_data/delivery_organisations#missing'
      end

      get 'time-period', to: 'view_data/time_period#edit'
      post 'time-period', to: 'view_data/time_period#update'

      resources :services, only: [:show], controller: 'view_data/services'
      resources :departments, only: [:show], controller: 'view_data/departments'
      resources :delivery_organisations, only: [:show], controller: 'view_data/delivery_organisations'
    end
  end

  match "/404", to: "errors#not_found", :via => :all
  match "/500", to: "errors#internal_server_error", :via => :all
end
