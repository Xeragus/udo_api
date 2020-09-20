Rails.application.routes.draw do
  resources :tags
  resources :tasks
  resources :goals
  
  get 'task-completion-data', to: 'tasks#task_completion_data'

  scope :users do
    post :register, to: 'users#register'
    post :login, to: 'users#login'
    get 'auto-login', to: 'users#auto_login'
  end


end
