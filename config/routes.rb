Rails.application.routes.draw do
  devise_for :users, {
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      sign_out_via: [:delete]
    }
  }

  ActiveAdmin.routes(self)

  root 'home#show'

  resources :wizards, only: [:new, :create]

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :auth, only: [:create]
      resources :passwords, only: [:create]
      resource :profile, only: [:show] do
        resource :avatar, only: [:update]
      end
    end
  end

  namespace :manager do
    root 'categories#index'
    resources :categories, only: [:index, :show, :edit, :update, :destroy]
  end

  comfy_route :cms_admin, path: '/admin/cms'

  # Make sure this routeset is defined last
  comfy_route :cms, path: '/', sitemap: false

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
