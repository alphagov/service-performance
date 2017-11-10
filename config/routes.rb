Rails.application.routes.draw do
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

  scope :publish do
    get "/service-manual", to: "pages#service_manual"
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
end
