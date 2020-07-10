Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/users/:id/transactions', to: 'transactions#index', as: 'transactions', id: /[A-Za-z0-9\.]+/
  get '/users/:id/', to: 'users#index', as: 'users', id: /[A-Za-z0-9\.]+/
  get '/users/:id/fines', to: 'fines#index', as: 'fines', id: /[A-Za-z0-9\.]+/
  get '/users/:id/holds', to: 'holds#index', as: 'holds', id: /[A-Za-z0-9\.]+/
end
