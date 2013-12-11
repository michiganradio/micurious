=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
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
  match '/admin/questions/search/', to: 'admin/questions#search', via: 'post', as: 'search_admin_questions'
  match '/search', to: 'questions#search', via: 'get', as: 'search_user_questions'
  match '/ask_mobile', to: 'questions#ask_mobile', via: 'get', as: 'ask_mobile'
  match '/submit_mobile', to: 'questions#submit_mobile', via: 'post', as: 'submit_mobile'
  resources :questions, only: [:create, :new, :show]
  resources :voting_rounds, only: [:show]

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
