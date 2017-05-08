Rails.application.routes.draw do
  root 'pages#homepage'

  scope 'performance-data' do
    get 'government', to: 'metrics#index'
  end
end
