# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'welcome/index'

  resources :articles do
    resources :comments
  end

  root 'admin/orders#index'


  # Custom routes for ActiveAdmin
  get '/submit_order/:id', to: 'admin/orders#submit_order', as: :submit_order
  get '/update_order_addresses/:id', to: 'admin/addresses#update_order_addresses', as: :update_order_addresses
  get '/approve_order/:id', to: 'admin/orders#approve_order', as: :approve_order
end
