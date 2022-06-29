# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'welcome/index'

  resources :articles do
    resources :comments
  end

  root 'admin/orders#index'

  get '/fetch_netsuite_orders', to: 'welcome#fetch_netsuite_orders'

  # Custom routes for ActiveAdmin
  get '/submit_order/:id', to: 'admin/orders#submit_order', as: :submit_order
  get '/approve_order/:id', to: 'admin/orders#approve_order', as: :approve_order
end
