Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "categories#index"

  resources :bases, only: [:index]
  resources :searches, only: [:index]
  resources :bookshelves, only: [:index, :show]
  resources :studies, only: [:index,:show]
  resource :mypage, only: [:show, :update]
  resources :relationships, only: [:create, :destroy]
  
  resources :word_marks do 
    collection do
      patch ':word_id/update_review_date', to: 'word_marks#update_review_date', as: 'update_review_date'
    end
  end
  resources :categories do
    get 'marked_words', to: 'words#marked', as: 'marked_words'
  end

  resources :categories do
    resources :words
    resources :word_marks, only: [:index]
  end

  resources :groups do
    resources :group_words, only: [:index, :show, :create]
  end

  resources :words do
    resources :word_marks do
      collection do
        post :toggle
      end
    end
  end
  
  resources :relationships, only: [:create, :destroy] do
    collection do
      post 'search', to: 'relationships#search'
    end
  end
end
