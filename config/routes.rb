Rails.application.routes.draw do
  root 'pages#homepage'

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

  get "/how-to-use", to: "pages#how_to_use"

  match "/404", to: "errors#not_found", :via => :all
  match "/500", to: "errors#internal_server_error", :via => :all

end
