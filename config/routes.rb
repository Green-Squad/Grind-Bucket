Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}
  
  get 'games',              to: 'games#index',    as: 'games_index'
  get ':id',                to: 'games#show',     as: 'game'
  get 'games/approve/:id',  to: 'games#approve',  as: 'approve_game'
  get 'games/reject/:id',   to: 'games#reject',   as: 'reject_game'
  
end
