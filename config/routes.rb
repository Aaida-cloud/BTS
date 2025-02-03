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


  get "home/index"
  root to: "home#index"

  get "admin_dashboard", to: "admin#index"
  patch "admin/update_user_type/:id", to: "admin#update_user_type", as: :update_user_type_admin_user
  patch "admin/toggle_user/:id", to: "admin#toggle_user", as: :toggle_user_admin
end
