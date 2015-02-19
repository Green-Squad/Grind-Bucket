Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}
  
  root 'games#index'
  
  get   'games',              to: 'games#index',      as: 'games_index'
  get   ':id',                to: 'games#show',       as: 'game'
  post  'games/new',          to: 'games#create',     as: 'new_game'
  get   'games/approve/:id',  to: 'games#approve',    as: 'approve_game'
  get   'games/reject/:id',   to: 'games#reject',     as: 'reject_game'
  
  post  'max_ranks/new',      to: 'max_ranks#create', as: 'new_max_rank'
  
end
