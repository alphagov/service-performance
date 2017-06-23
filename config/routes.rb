Rails.application.routes.draw do
  root 'pages#homepage'

  scope 'performance-data' do
    get 'departments', scope: 'departments', to: 'metrics#index'
    get 'delivery_organisations', scope: 'delivery_organisations', to: 'metrics#index'
    get 'services', scope: 'services', to: 'metrics#index'

    resources :departments, only: [] do
      resources :services, only: [:index, :show]
    end
  end
end
