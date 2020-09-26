Rails.application.routes.draw do
  resources :tags
  resources :tasks
  resources :goals
  
  get 'task-completion-data', to: 'tasks#task_completion_data'
  get 'task-stats-header-data', to: 'users#task_stats_header_data'

  scope :users do
    post :register, to: 'users#register'
    post :login, to: 'users#login'
    get 'auto-login', to: 'users#auto_login'
  end
end
