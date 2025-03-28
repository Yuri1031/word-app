Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "categories#index"

  resources :bases, only: [:index]
  resources :bookshelves, only: [:index, :show]
  resources :studies, only: [:index,:show]
  resource :mypage, only: [:show, :update]
  resources :friends, only: [:create, :destroy]
  

  resources :categories do
    resources :words
  end

  resources :groups do
    resources :group_words, only: [:index, :show]
  end

  resources :words do
    resources :word_marks do
      collection do
        post :toggle
     end
    end
  end
  
end
