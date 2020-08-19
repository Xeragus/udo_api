Rails.application.routes.draw do
  resources :tasks
  scope :users do
    post :register, to: 'users#register'
    post :login, to: 'users#login'
    get 'auto-login', to: 'users#auto_login'
  end
end
