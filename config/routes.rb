# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1 do
    resource :sessions, only: %i[create destroy]

    resources :users do
      collection do
        get :me
        put :change_password
      end

      resources :companies, shallow: true do
        resources :orders, shallow: true do
          member do
            get :pdf
          end
          resources :order_items, shallow: true
        end
      end
    end
  end
end
