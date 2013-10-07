Curiouscity::Application.routes.draw do
  resources :voting_round_questions
  resources :voting_rounds do
    member do
      post :add_question
    end
  end
  resources :admins
  resources :sessions, only: [:new, :create, :destroy]
  resources :questions do
    member do
      post :add_question_to_voting_round
      post :deactivate
    end
  end

  root  'welcome#home'
  match '/ask_question', to: 'questions#ask_question',     via: 'post'
  match '/signup',       to: 'admins#new',        via: 'get'
  match '/signin',       to: 'sessions#new',      via: 'get'
  match '/signout',      to: 'sessions#destroy',  via: 'delete'
  match '/admin_main',   to: 'admins#main',       via: 'get'

end
