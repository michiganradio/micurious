Curiouscity::Application.routes.draw do
  root  'voting_rounds#home'
  match '/about', to: 'voting_rounds#about', via: 'get'
  match '/ask_question', to: 'questions#new',     via: 'post'
  match '/confirm_question', to: 'questions#confirm', via: 'post'
  match '/vote', to: 'voting_rounds#vote', via: 'post'
  match '/vote_widget', to: 'widget#vote_widget', via: 'get'
  match '/widget_vote', to: 'widget#vote', via: 'post'
  match '/ask_widget', to: 'widget#ask_widget', via: 'get'
  match '/picture_question', to: 'questions#picture', via: 'post'
  match '/find_pictures', to: 'questions#find_pictures', via: 'post'
  match '/questions/:status(/:category_name)', to: 'questions#filter', via: 'get', as: 'filter_questions', constraints: { status: /answered|archive/}
  resources :questions, except: [:index]
  resources :voting_rounds

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
    resources :answers

    match '/signup',       to: 'users#new',        via: 'get'
    match '/signin',       to: 'sessions#new',      via: 'get'
    match '/signout',      to: 'sessions#destroy',  via: 'delete'
  end

  match '/admin',   to: 'admin/users#main',       via: 'get'
end
