Rails.application.routes.draw do
  get "admin/index"

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

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
        post 'assign_bug_to_me/:bug_id', to: 'projects#assign_bug_to_me', as: 'assign_bug_to_me'
        delete 'unassign_bug/:bug_id', to: 'projects#unassign_bug', as: 'unassign_bug'
      end
    end
  end


  namespace :qa do
    resources :projects, only: [:index, :show] do
      resources :bugs, only: [:new, :create, :show]
    end
  end

  get "home/index"
  root to: "home#index"

  get "admin_dashboard", to: "admin#index"
  patch "admin/update_user_type/:id", to: "admin#update_user_type", as: :update_user_type_admin_user
  patch "admin/toggle_user/:id", to: "admin#toggle_user", as: :toggle_user_admin
end
