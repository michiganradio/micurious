Curiouscity::Application.routes.draw do
  root  'welcome#home'
  match '/ask_question', to: 'admin/questions#new',     via: 'get'

  resources :questions

  namespace 'admin' do
    resources :voting_round_questions
    resources :voting_rounds do
      member do
        post :add_question
      end
    end
    resources :users
    resources :sessions, only: [:new, :create, :destroy]
    resources :questions do
      member do
        post :add_question_to_voting_round
        post :deactivate
      end
    end

    match '/signup',       to: 'users#new',        via: 'get'
    match '/signin',       to: 'sessions#new',      via: 'get'
    match '/signout',      to: 'sessions#destroy',  via: 'delete'
  end

  match '/admin_main',   to: 'admin/users#main',       via: 'get'
end
