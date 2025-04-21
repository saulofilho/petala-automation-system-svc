# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1 do
    resources :users, only: %i[create update destroy] do
      get :me, on: :collection
    end

    resource :sessions, only: %i[create destroy]
  end
end
