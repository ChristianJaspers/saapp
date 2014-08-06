Rails.application.routes.draw do
  scope "(:locale)", locale: /da/, defaults: {locale: 'en'} do
    as :user do
      patch 'confirmation' => 'confirmations#update', as: :update_user_confirmation, controller: 'confirmations'
    end

    devise_for :users, {
      path: '',
      path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        sign_out_via: [:delete]
      },
      controllers: {
        confirmations: 'confirmations'
      }
    }

    ActiveAdmin.routes(self)

    root 'home#show'

    resources :wizards, only: [:new, :create]


    namespace :manager do
      root 'product_groups#index'
      resources :product_groups, only: [:index, :show, :create, :edit, :update, :destroy]
      resources :users, only: [:index, :create, :edit, :update, :destroy]
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :auth, only: [:create]
      resources :resources, only: [:index]
      resource :passwords, only: [:create, :update]
      resource :profile, only: [:show] do
        resource :avatar, only: [:update]
      end
      resources :arguments, only: [:create, :update] do
        resource :ratings, only: [:create]
      end
    end
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
