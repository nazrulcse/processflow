Rails.application.routes.draw do

  resources :tasks do
    resources :comments do
      member do
        get 'reply'
      end
    end
  end

  resources :checklists do
    resources :checklist_items do
      member do
        get 'complete'
      end
    end
  end
  get  "/count_item", :to => "checklist_items#count_item"
  post "/import", :to => "tasks#import"
  post "/search", :to => "tasks#search_task"
  post "/update_position", :to => "tasks#update_position"
  post "/remove_task", :to => "tasks#remove_task"
  post "/destroy_notification_subcription", :to => "tasks#destroy_notification_subcription"
  post "/feeds", :to => "projects#get_feeds"

  post "/notification", :to => "tasks#get_notification"

  resources :attachments do
    member do
      get 'download'
    end
  end

  resources :settings

  resources :projects do
    resources :invites
    resources :tasks do
      member do
        post "assign"
        delete "unassign"
      end
    end
    member do
      get 'statistics'
    end
  end

  resources :tasks do
    resources :attachments
  end

  get "/accept", :to => "invites#accept_invitation"
  post "/user", :to => "invites#user_create"
  get 'welcome/index'


  #devise_for :users #, :controllers => {:registrations => 'registrations'}
  #resources :users
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks"}
  devise_scope :user do
    get "/account", :to => "devise/registrations#new"
    post "/account", :to => "devise/registrations#create"
    get "/profile", :to => "devise/registrations#edit"
    put "/profile", :to => "registrations#update"
    get "/login", :to => "devise/sessions#new"
    post "/login", :to => "devise/sessions#create"
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'welcome#dashboard'
  root 'welcome#index'
  #get '/register' => 'welcome#register'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get 'dashboard/:id' => 'welcome#dashboard', as: :dashboard
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
