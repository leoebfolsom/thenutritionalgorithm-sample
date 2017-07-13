#require 'api_constraints'
Rails.application.routes.draw do




  get 'subscribe/new'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
                                       :registrations => "users/registrations",
                                       :confirmations => "confirmations",
                                       :passwords => "passwords" }


  get 'password_resets/new'

  get 'password_resets/edit'
  
  root 'static_pages#home'


  get 'cancel_subscription' => 'subscribe#cancel_subscription'
  get 'about' =>  'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'faq' => 'static_pages#faq'
  get 'explore' => 'lists#index'
  get 'charts' => 'static_pages#charts'
  get 'cooking_with_leo' => 'static_pages#cooking_with_leo'
  get 'terms_of_service_and_privacy_policy' => 'static_pages#terms_of_service_and_privacy_policy'
  get 'buy_list' => 'lists#buy_list'
  get 'instagram_dish' => 'lists#instagram_dish'
  get 'instagram_dish_from_home' => 'lists#instagram_dish_from_home'
  get 'create_list_buy' => 'lists#create_list_buy'
  
  get 'hard_delete_user_from_profile' => 'users#hard_delete_user_from_profile'
  get 'skip_onboarding' => 'static_pages#skip_onboarding'

  get 'logged_in_reset' => 'users#logged_in_reset'

  get 'addfood'  => 'foods#new'
  get 'add_list_buy'  => 'list_buys#new'
  get 'add_person' => 'lists#add_person'
  get 'add_person_submit' => 'lists#add_person_submit'
  get 'edit_person' => 'lists#edit_person'
  get 'edit_person_submit' => 'lists#edit_person_submit'
  get 'build_list' => 'lists#build_list'
  get 'addquantity'  => 'quantities#new'
  get 'add_food_stepwise' => 'quantities#add_food_stepwise'
  get 'add_food_stepwise_skip' => 'quantities#add_food_stepwise_skip'  
  get 'delete_food_stepwise_skip' => 'quantities#delete_food_stepwise_skip' 
  get 'delete_food_stepwise' => 'quantities#delete_food_stepwise'

  get 'create_random_list_name' => 'lists#create_random_list_name'
  get 'shuffle_stepwise' => 'lists#shuffle_stepwise'
  get 'start_list_add' => 'lists#start_list_add'
  get 'start_list_add_undo' => 'lists#start_list_add_undo'
  post 'comment' => 'comments#create'
  get 'search' => 'lists#search'
  get 'home_search' => 'static_pages#home_search'
  get 'rich_in_nutrient' => 'lists#rich_in_nutrient'
  get 'browse' => 'lists#browse'
  get 'search_and_add' => 'lists#search_and_add'
  get 'find_good_list' => 'lists#find_good_list'

  post 'favorite_to_list' => 'lists#favorite_to_list'
  get 'onboarding_favorite' => 'static_pages#onboarding_favorite'
  get 'see_notifications' => 'static_pages#see_notifications'

  get 'static_chart_generate' => 'static_pages#static_chart_generate'
  get 'list_preview' => 'static_pages#list_preview'

  get 'create' => 'quantities#create'


  get 'hard_delete' => 'lists#hard_delete'


  get 'favorite' => 'lists#favorite'
  get 'user_favorite' => 'users#user_favorite'
  get 'skip_liker' => 'users#skip_liker'
  get 'search_favorite' => 'users#search_favorite'
  get 'search_dislike' => 'users#search_dislike'
  get 'user_dishes' => 'users#user_dishes'
#  get 'user_spoons' => 'users#user_spoons'
  get 'user_likes' => 'users#user_likes'
  get 'user_dislikes' => 'users#user_dislikes'
  get 'undo_hard_delete_user' => 'users#undo_hard_delete_user'
  get 'chart_generate' => 'users#chart_generate'
  get 'chart_click' => 'users#chart_click'

  get 'undo_favorite' => 'users#undo_favorite'




  get 'fork' => 'lists#fork'
#  get 'spoon' => 'lists#spoon'
  get 'like' => 'activities#like'
  get 'pantry' => 'quantities#pantry'

  get 'pantry_remove' => 'quantities#pantry_remove'

  get 'clear_user_comments' => 'comments#clear_user_comments'
  get 'clear_user_comments_all' => 'comments#clear_user_comments_all'


  get 'send_checklist_mailer' => 'lists#send_checklist_mailer'
  
  resources :foods
  resources :activities do
    get 'like'
  end
  resources :posts, :has_many => :comments
  resources :list_buys
  resources :images  
  resources :quantities do
    get 'create'
    get 'pantry'
    get 'pantry_remove'
    get 'add_food_stepwise'
    get 'add_food_stepwise_skip'
    get 'delete_food_stepwise_skip'
    get 'delete_food_stepwise'
  end
  resources :comments do
    post 'create'
    get 'clear_user_comments'
    get 'clear_user_comments_all'
  end
  resources :static_pages do
    get 'skip_onboarding'
    get 'onboarding_favorite'
    get 'static_chart_generate'
    get 'see_notifications'
    get 'home_search'
  end

  resources :lists do
    
    get 'instagram_dish'
    get 'instagram_dish_from_home'
    get 'add_person'
    get 'add_person_submit'
    get 'edit_person'
    get 'edit_person_submit'
    post 'favorite_to_list'
    get 'create_random_list_name'
    get 'shuffle_stepwise'
    get 'start_list_add'
    get 'start_list_add_undo'
    get 'addblanklist'
    get 'search'
    get 'rich_in_nutrient'
    get 'browse'
    get 'search_and_add'
    get 'create'
    get 'buy_list'
    get 'build_list'

    get 'hard_delete'

    get 'fork'
#    get 'spoon'



  end
  resources :users do
    get 'search_favorite'
    get 'search_dislike'
    get 'undo_hard_delete_user'

    get 'undo_favorite'

    get 'logged_in_reset'
    get 'user_favorite'
    get 'skip_liker'
    get 'hard_delete_user_from_profile'
    put 'update_bio'
    put 'update_settings'
#    get 'user_spoons'
    get 'user_dishes'
    get 'user_likes'
    get 'user_dislikes'
    get 'chart_generate'
    get 'chart_click'
    member do
      get :following, :followers
    end
  end



  resources :lists, only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]

  resources :charges
  resources :subscribe

  
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
#  root                'static_pages#home'
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

  # Api definition
  constraints subdomain: 'api' do
    namespace :api, defaults: {format: 'json'} do
      namespace :v1 do
        resources :lists
      end
    end
  end
end
