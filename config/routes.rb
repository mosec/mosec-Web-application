require 'resque/server'

Radar::Application.routes.draw do  
  mount Resque::Server, :at => '/resque'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match '/auth/:provider/callback' => 'sources#create'
  match '/auth/failure' => 'sources#index'

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match '/sign_up' => 'users#new', as: :sign_up
  match '/sign_in' => 'user_sessions#new', as: :sign_in
  match '/logout' => 'user_sessions#destroy', as: :logout
  match '/account' => 'users#edit', as: :account
  match '/dashboard' => 'dashboards#show', as: :dashboard
  match '/linked_accounts' => 'sources#index', as: :linked_accounts

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :users, only: [:new, :create, :edit, :update]
  resource :user_session, only: [:new, :create, :destroy]
  resource :dashboard, only: [:show]
  resources :sources, only: [:index, :destroy]
  resources :contacts, only: [:show]
  resources :search, only: [:index]

  # Sample resource route with options:
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
  resources :phone_data, only: [] do
    collection do
      post :synchronize, defaults: { format: :json }
    end
  end
  resources :email_accounts, only: [] do
    collection do
      post :ready
    end
  end
  resources :emails, only: [:create] do
    collection do
      post :failure
    end
  end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'base#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
