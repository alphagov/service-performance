Rails.application.routes.draw do

  scope :v1 do
    scope 'data' do
      resource :government, only: [:show]

      resources :departments, only: [:index, :show], controller: 'departments' do
        resources :services, only: [:index], controller: 'services'
      end
      resources :services, only: [:index, :show], controller: 'services'
    end
  end

end
