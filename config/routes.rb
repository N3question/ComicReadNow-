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
    patch '/users/information', to: 'users#update', as: 'information'
    get 'users/rank_index', to: 'users#rank_index', as: 'user_rank_index'
    get 'comics/comic_site_index', to: 'comics#comic_site_index', as: 'comic_site_index'
    get '/bookmarks', to: 'bookmarks#index', as: 'bookmark'
    resources :comics, only: [:top, :show]
  end
  
  namespace :admin do
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
