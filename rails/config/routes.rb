Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope 'users/:id/' do
    constraints id: /[A-Za-z0-9\.]+/ do
      get '/', to: 'users#index'
      get 'fines/email', to: 'fines#email'
      get 'fines', to: 'fines#index'
      put 'fines', to: 'fines#pay'
      get 'requests', to: 'requests#index'
      get 'loans', to: 'loans#index'
      delete 'requests/:request_id', to: 'requests#delete' 
      post 'loans/:barcode/renew',  to: 'loans#renew'
    end
  end

end
