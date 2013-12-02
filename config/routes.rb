Curiouscity::Application.routes.draw do
  root  'voting_rounds#home'
  match '/about', to: 'voting_rounds#about', via: 'get'
  match '/ask_question', to: 'questions#new',     via: 'post'
  match '/confirm_question', to: 'questions#confirm', via: 'post'
  match '/vote', to: 'voting_rounds#vote', via: 'post'
  match '/vote_widget', to: 'widget#vote_widget', via: 'get'
  match '/widget_vote', to: 'widget#vote', via: 'post'
  match '/IE8_ask_widget', to: 'widget#IE8_ask_widget', via: 'get'
  match '/ask_widget', to: 'widget#ask_widget', via: 'get'
  match '/picture_question', to: 'questions#picture', via: 'post'
  match '/find_pictures', to: 'questions#find_pictures', via: 'post'
  match '/questions/:status(/:category_name)', to: 'questions#filter', via: 'get', as: 'filter_questions', constraints: { status: /answered|archive/}
  match '/admin/questions/tag/:tag', to: 'admin/questions#filter_by_tag', via: 'get', as: 'filter_admin_questions'
<<<<<<< HEAD
  match '/admin/search/:search_text', to: 'admin/users#search', via: 'get', as: 'search_admin_questions'
  resources :questions, only: [:create, :new, :show]
  resources :voting_rounds, only: [:show]
=======
  match '/admin/search/', to: 'admin/users#search', via: 'post', as: 'search_admin_questions'
  resources :questions, except: [:index]
  resources :voting_rounds
>>>>>>> AS/LM - #225 - add question search form in main page

  namespace :admin do
    resources :categories do
      member do
        post :deactivate
      end
    end
    resources :voting_round_questions
    resources :voting_rounds, except: [:destroy] do
      member do
        post :add_question
        post :remove_question
      end
    end
    resources :users
    resources :sessions, only: [:new, :create, :destroy]
    resources :questions do
      member do
        post :add_question_to_voting_round
      end
    end
    resources :answers do
      collection do
        get :reorder
        post :sort
      end
    end

    match '/signup',       to: 'users#new',        via: 'get'
    match '/signin',       to: 'sessions#new',      via: 'get'
    match '/signout',      to: 'sessions#destroy',  via: 'delete'
  end

  match '/admin',   to: 'admin/users#main',       via: 'get'
end
