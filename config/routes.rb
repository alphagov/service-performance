Rails.application.routes.draw do
  # TODO - constraints subdomain: 'publicapi' do
  scope 'v1' do
    # 'data' resource routes
    scope 'data' do
      get 'government', to: 'data#government', as: 'government_data'

      get 'government/latest',
          to: 'data#government_latest',
          as: 'government_latest_data'

      # government data for a :year with optional quarter range
      get 'government/:year(/:quarter_from,:quarter_to)',
          year: /[0-9]{4}/,
          quarter_from: /Q[1-4]{1}/,
          quarter_to: /Q[1-4]{1}/,
          to: 'data#government'

      get 'departments', to: 'data#departments', as: 'departments_data'

      get 'departments/:department_natural_key',
          to: 'data#department',
          as: 'department_data',
          department_natural_key: /[A-Z]{2}[0-9]{1,4}/

      get 'services', to: 'data#services', as: 'services_data'

      get 'services/:service_natural_key',
          to: 'data#service',
          as: 'service_data',
          service_natural_key: /[0-9]{4}/
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
