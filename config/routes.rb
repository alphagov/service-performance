Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  namespace :api, module: nil do
    scope :v1 do
      scope 'data' do
        resource :government, only: [:show], controller: 'api/governments' do
          resources :metrics, only: [:index], controller: 'api/government_metrics', defaults: { format: 'json' }
        end

        resources :departments, only: [:index, :show], controller: 'api/departments' do
          resources :metrics, only: [:index], controller: 'api/department_metrics', defaults: { format: 'json' }
        end

        resources :delivery_organisations, only: [:index, :show], controller: 'api/delivery_organisations' do
          resources :metrics, only: [:index], controller: 'api/delivery_organisation_metrics', defaults: { format: 'json' }
        end

        resources :services, only: [:index, :show], controller: 'api/services' do
          resources :metrics, only: [:index], controller: 'api/service_metrics', defaults: { format: 'json' }
        end
      end
    end
  end

  ActiveAdmin.routes(self)

  namespace :publish, path: 'publish-data', module: nil do
    get "/service-manual", to: "publish_data/pages#service_manual"

    resources :services, only: [] do
      constraints year: /\d{4}/, month: /\d{2}/ do
        get 'metrics/:year/:month(/:publish_token)', to: 'publish_data/monthly_service_metrics#edit', as: :metrics
        patch 'metrics/:year/:month(/:publish_token)', to: 'publish_data/monthly_service_metrics#update'
      end
    end

    devise_for :users
  end

  namespace :view_data, path: 'view-data', module: nil do
    root 'view_data/pages#homepage'
    get "/how-to-use", to: "view_data/pages#how_to_use"

    scope 'performance-data' do
      scope :government do
        get 'metrics/:group_by', to: 'view_data/government_metrics#index',
          group_by: Regexp.union(Metrics::Group::Department, Metrics::Group::DeliveryOrganisation, Metrics::Group::Service),
          defaults: { group_by: Metrics::Group::Department },
          as: :government_metrics
      end

      resources :departments, only: [] do
        get 'metrics/:group_by', to: 'view_data/department_metrics#index',
          group_by: Regexp.union(Metrics::Group::DeliveryOrganisation, Metrics::Group::Service),
          defaults: { group_by: Metrics::Group::DeliveryOrganisation },
          as: :metrics
      end

      resources :delivery_organisations, only: [] do
        get 'metrics/:group_by', to: 'view_data/delivery_organisation_metrics#index', group_by: Metrics::Group::Service, as: :metrics
      end

      resources :services, only: [:show], controller: 'view_data/services'
    end
  end

  match "/404", to: "errors#not_found", :via => :all
  match "/500", to: "errors#internal_server_error", :via => :all
end
