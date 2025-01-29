Rails.application.routes.draw do
<<<<<<< Updated upstream
=======
  get "admin/index"
>>>>>>> Stashed changes
  devise_for :users, controllers: {
  registrations: 'users/registrations'
 }


  get "home/index"
  root to: "home#index"
<<<<<<< Updated upstream

=======
  get "admin_dashboard", to: "admin#index"

  patch "admin/update_user_type/:id", to: "admin#update_user_type", as: :update_user_type_admin_user
  patch "admin/toggle_user/:id", to: "admin#toggle_user", as: :toggle_user_admin
>>>>>>> Stashed changes
end
