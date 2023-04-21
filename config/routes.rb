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
    resources :comics, only: [:top, :show, :new, :create] do
      get '/top_comic_info', to: 'comics#top_comic_info', on: :collection, as: 'top_comic_info'
      # get '/top_new', to: 'comics#top_new', on: :collection, as: 'top_new'
      # post '/top_new', to: 'comics#top_create', on: :collection, as: 'top'
      # get '/top_show', to: 'comics#top_show', as: 'top_show'
      get '/sale_index', to: 'comics#sale_index', on: :collection, as: 'sale_index'
      get '/review_count_index', to: 'comics#review_count_index', on: :collection, as: 'review_count_index'
      get '/search_index', to: 'comics#search_index', on: :collection, as: 'search_index'
      get '/comic_site_index', to: 'comics#comic_site_index', on: :collection, as: 'comic_site_index'
      get '/bookmarks', to: 'bookmarks#index', on: :collection, as: 'bookmarks'
      get '/bookmarks', to: 'bookmarks#new', as: 'bookmark'
      delete '/bookmarks', to: 'bookmarks#destroy', on: :collection, as: 'destroy_bookmark'
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
