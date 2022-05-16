# frozen_string_literal: true

Rails.application.routes.draw do
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
  end
  devise_for :users

  get 'welcome/index'

  resources :articles do
    resources :comments
  end

  root 'welcome#index'
end
