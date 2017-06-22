Rails.application.routes.draw do

  scope :v1 do
    scope 'data' do
      resource :government, only: [:show] do
        resources :metrics, only: [:index], controller: 'government_metrics'
      end

      resources :departments, only: [:index, :show], controller: 'departments' do
        resources :metrics, only: [:index], controller: 'department_metrics'
      end

      resources :delivery_organisations, only: [:index, :show], controller: 'delivery_organisations' do
        resources :metrics, only: [:index], controller: 'delivery_organisation_metrics'
      end

      resources :services, only: [:index, :show], controller: 'services' do
        resources :metrics, only: [:index], controller: 'service_metrics'
      end
    end
  end

end
