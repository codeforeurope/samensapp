Samensapp::Application.routes.draw do
  namespace :dashboard do
    get "", :action => :incoming
    get :incoming
    get :sent
    get :confirmed
    get :to_invoice
  end

  resources :events

  resources :buildings do
    member do
      match "/openingtimes", :to => "buildings#openingtimes"
    end
  end

  resources :booking_requests do
    collection do
      get :find_user_by_email
    end
    member do
      put :assign_to_self
      put :assign_to_other
      put :cancel
    end
    resource :offer do
      put :accept
      put :decline
      put :cancel
      put :send_offer
      get :ical
    end
  end
  get '/view_request/:code', :to => "booking_requests#by_code", :as => :view_request
  get '/view_offer/:code', :to => "offers#by_code", :as => :view_offer
  resources :rooms do
    resources :pictures do
      match '/carousel', :to => "pictures#carousel"
    end
    resources :room_configurations
    member do
      get :prices
    end
  end
  get '/rooms_in_building/:building_id', :to => 'rooms#in_building', :as => :rooms_in_building

  resources :organizations do
    member do
      get :crop
    end
    resources :buildings
  end

  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks"}
  #resource to manage the user profile
  devise_scope :user do
    match '/users/auth/:provider/setup', :to => "omniauth_callbacks#setup", :as => :user_omniauth_setup, :via => [:get, :post]
  end
  resource :user, :path => :profile, :except => :new, :controller => :profile, :as => :profile
  match 'users/profile' => 'users#profile'

  root :to => 'landing#index'


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
  # match ':controller(/:action(/:id))(.:format)'
end
