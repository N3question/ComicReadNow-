Rails.application.routes.draw do
  
  # namespace :public do
  #   get 'user_rankings/index'
  # end
  
  devise_for :users, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}
  scope module: :public do
    root to: 'comics#top'
    get 'users/my_page', to: 'users#my_page', as: 'my_page'
    get '/users/information/edit', to: 'users#edit', as: 'edit_information'
    patch '/users/information', to: 'users#update', as: 'update_information'
    get 'users/rank_index', to: 'users#rank_index', as: 'user_rank_index'
    resources :comics, only: [:top, :show, :new, :create, :edit, :update] do
      get '/top_comic_info', to: 'comics#top_comic_info', on: :collection, as: 'top_comic_info'
      get '/sale_index', to: 'comics#sale_index', on: :collection, as: 'sale_index'
      get '/user_select_index', to: 'comics#user_select_index', on: :collection, as: 'user_select_index'
      get '/review_count_index', to: 'comics#review_count_index', on: :collection, as: 'review_count_index'
      get '/search_index', to: 'comics#search_index', on: :collection, as: 'search_index'
      get '/next_coming_index', to: 'comics#next_coming_index', on: :collection, as: 'next_coming_index'
      get '/comic_site_index/:id', to: 'comics#comic_site_index', on: :collection, as: 'comic_site_index'
      get '/bookmarks', to: 'bookmarks#index', on: :collection, as: 'bookmarks'
      get '/bookmarks', to: 'bookmarks#new', as: 'bookmark'
      get '/:comic_id/bookmarks', to: 'bookmarks#destroy', as: 'destroy_bookmark'
      post '/read_judgement', to: 'comics#read_judgement', as: 'read_judgement'
    end
  end
  
  namespace :admin do
    get '/', to: 'users#top', as: 'top'
    get 'user/:id/information', to: 'users#information', as: 'information'
    get 'user/comment_index', to: 'users#comment_index', as: 'comment_index'
    get 'user/premium_index', to: 'users#premium_index', as: 'premium_index'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
