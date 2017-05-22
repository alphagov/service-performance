Rails.application.routes.draw do
  root 'pages#homepage'

  scope 'performance-data' do
    get 'government', to: 'metrics#index'

    resources :departments, only: [] do
      resources :services, only: [:index, :show]
    end
  end
end
