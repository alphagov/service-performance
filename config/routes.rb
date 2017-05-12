Rails.application.routes.draw do

  scope :v1 do
    scope 'data' do
      resources :services, only: [:index, :show], controller: 'services'
    end
  end

end
