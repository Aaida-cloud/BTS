Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get "home/index"
  root to: "home#index"

  get "admin/index"
  get "admin_dashboard", to: "admin#index"
  patch "admin/update_user_type/:id", to: "admin#update_user_type", as: :update_user_type_admin_user
  patch "admin/toggle_user/:id", to: "admin#toggle_user", as: :toggle_user_admin

  resources :projects do
    resources :bugs, only: [:new, :create, :index, :show, :edit, :update, :destroy]
    member do
      post :assign_users
      post :remove_user
    end
  end

  namespace :developer do
    resources :projects, only: [:index, :show] do
      member do
       get :bug_details
       patch :update_bug_status
      end
    end
  end

  namespace :qa do
    resources :projects, only: [:index, :show] do
      resources :bugs, only: [:new, :create, :show]
    end
  end

  namespace :api do
    namespace :v1 do
      get "admin/users", to: "admin#index"
      patch "admin/users/:id/update_role", to: "admin#update_user_type"
      patch "admin/users/:id/toggle_access", to: "admin#toggle_user"
    end
  end

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'login', to: 'auth#create'
        delete 'logout', to: 'auth#destroy'
        end

      resources :projects do
        member do
          post :assign_users
          delete :remove_user
        end
      end
    end
  end
end
