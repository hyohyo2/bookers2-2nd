Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  get 'search' => 'searches#search'
  get 'tagsearches' => 'tagsearches#search'
  resources :users, only: [:index, :show, :edit, :update] do
    get 'search_date' => 'users#search'
    resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
  end
  resources :books, only: [:index, :create, :show, :edit, :update, :destroy] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :notifications, only:[:update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
