Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "categories#index"

  resources :bases, only: [:index]
  resources :bookshelves, only: [:index, :show]
  resources :studies, only: [:index,:show]
  resource :mypage, only: [:show, :update]
  
  resources :word_marks do 
    collection do
      post :update_review_date
    end
  end
  
  resources :categories do
    get 'marked_words', to: 'words#marked', as: 'marked_words'
    resources :words do 
      post :share, on: :member
    end
    resources :word_marks, only: [:index]
  end

  resources :groups do
    resources :group_words, only: [:index, :show, :create]
    delete 'members/:id', to: 'groups#destroy_member', as: 'member'
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
      post 'search'
    end
  end

  resources :searches, only: [:index] do
    collection do
      get :suggestions
      get :search
    end
  end
  
end
