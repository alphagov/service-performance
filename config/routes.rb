Rails.application.routes.draw do
  root 'pages#homepage'

  scope 'performance-data' do
    scope :government do
      get 'metrics/:group_by', to: 'government_metrics#index', group_by: /department|delivery_organisation|service/, as: :government_metrics
    end

    resources :departments, only: [] do
      get 'metrics/:group_by', to: 'department_metrics#index', group_by: /department|delivery_organisation|service/, as: :metrics
    end

    resources :delivery_organisations, only: [] do
      get 'metrics/:group_by', to: 'delivery_organisation_metrics#index', group_by: /department|delivery_organisation|service/, as: :metrics
    end

    resources :services, only: [:show]
  end
end
