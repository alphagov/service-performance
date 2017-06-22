Rails.application.routes.draw do
  root 'pages#homepage'

  scope 'performance-data' do
    scope :government do
      get 'metrics/:group', to: 'government_metrics#index', group: /department|delivery_organisation|service/, as: :government_metrics
    end

    resources :departments, only: [] do
      get 'metrics/:group', to: 'department_metrics#index', group: /department|delivery_organisation|service/, as: :metrics
    end

    resources :delivery_organisations, only: [] do
      get 'metrics/:group', to: 'delivery_organisation_metrics#index', group: /department|delivery_organisation|service/, as: :metrics
    end

    resources :services, only: [:show]
  end
end
