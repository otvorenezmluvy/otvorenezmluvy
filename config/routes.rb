Crowdcloud::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :users

  resource :dashboard, controller: :dashboard do
    post :filter
  end

  namespace :admin do
    resources :comments do
      resources :reports
    end
    resources :spaceship_settings
    resources :heuristics
    resources :users do
      member do
        post :ban
        post :unban
        get :ban_ip
        post :ban_ip
        post :unban_ip
      end
    end
  end

  resource :comments do
    get :recent, on: :collection
  end

  resources :documents do
    get :search, :on => :collection
    post :quickfacet, :on => :collection
    post :toggle_visibility, :on => :collection
    post :watch, :on => :member
    post :unwatch, :on => :member
    resources :comments do
      member do
        post :vote_up
        post :vote_down
        post :flag
        post :flag_reason
        put :report
        post :toggle
      end
    end
    resources :questions
  end

  root :to => 'documents#index'

  match ':slug', :via => :get, :to => 'static_pages#show', :as => 'static_page'
  match ':slug', :via => :put, :to => 'static_pages#update', :as => 'static_page'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
