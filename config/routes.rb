Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  namespace :api, module: nil do
    scope :v1 do
      scope 'data' do
        resource :government, only: [:show] do
          resources :metrics, only: [:index], controller: 'government_metrics', defaults: { format: 'json' }
        end

        resources :departments, only: [:index, :show], controller: 'departments' do
          resources :metrics, only: [:index], controller: 'department_metrics', defaults: { format: 'json' }
        end

        resources :delivery_organisations, only: [:index, :show], controller: 'delivery_organisations' do
          resources :metrics, only: [:index], controller: 'delivery_organisation_metrics', defaults: { format: 'json' }
        end

        resources :services, only: [:index, :show], controller: 'services' do
          resources :metrics, only: [:index], controller: 'service_metrics', defaults: { format: 'json' }
        end
      end
    end
  end

  scope :publish do
    get "/service-manual", to: "pages#service_manual"
    ActiveAdmin.routes(self)
  end

  namespace :publish, module: nil do
    resources :services, only: [] do
      constraints year: /\d{4}/, month: /\d{2}/ do
        get 'metrics/:year/:month(/:publish_token)', to: 'monthly_service_metrics#edit', as: :metrics
        patch 'metrics/:year/:month(/:publish_token)', to: 'monthly_service_metrics#update'
      end
    end

    devise_for :users
    root 'pages#homepage'
  end

  namespace :view_data, path: 'view-data', module: nil do
    root 'view_data/pages#homepage'
    get "/how-to-use", to: "pages#how_to_use"

    scope 'performance-data' do
      scope :government do
        get 'metrics/:group_by', to: 'government_metrics#index',
          group_by: Regexp.union(Metrics::Group::Department, Metrics::Group::DeliveryOrganisation, Metrics::Group::Service),
          defaults: { group_by: Metrics::Group::Department },
          as: :government_metrics
      end

      resources :departments, only: [] do
        get 'metrics/:group_by', to: 'department_metrics#index',
          group_by: Regexp.union(Metrics::Group::DeliveryOrganisation, Metrics::Group::Service),
          defaults: { group_by: Metrics::Group::DeliveryOrganisation },
          as: :metrics
      end

      resources :delivery_organisations, only: [] do
        get 'metrics/:group_by', to: 'delivery_organisation_metrics#index', group_by: Metrics::Group::Service, as: :metrics
      end

      resources :services, only: [:show]
    end
  end

  match "/404", to: "errors#not_found", :via => :all
  match "/500", to: "errors#internal_server_error", :via => :all
end
