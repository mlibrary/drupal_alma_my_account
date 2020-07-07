Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/users/:id/transactions', to: 'transactions#index', as: 'transactions'
  get '/users/:id', to: 'users#index', as: 'users'
end
