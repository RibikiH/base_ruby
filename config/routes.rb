Rails.application.routes.draw do

  root 'pages#index'

  get "/mng", to: "mng/top#index", as: "admin_root"
  namespace :mng do
    resources :admins, except: [:show]
  end
  devise_for :admins, path: :mng

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end