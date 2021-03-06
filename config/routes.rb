Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}

  root    'home#index'

  get     'search',                   to: 'search#search',              as: 'search'
  get     'search-items',             to: 'search#autocomplete',        as: 'search_autocomplete'

  post     'user',                    to: 'fingerprint#lookupUser',     as: 'lookup_user'
  post     'identifier',              to: 'fingerprint#update',         as: 'update_identifier'

  get     'games',                    to: 'games#index',                as: 'games_index'
  get     ':id',                      to: 'games#show',                 as: 'game'
  post    'games/new',                to: 'games#create',               as: 'new_game'
  patch   'games/update/:id',         to: 'games#update',               as: 'edit_game'
  get     'games/approve/:id',        to: 'games#approve',              as: 'approve_game'
  get     'games/reject/:id',         to: 'games#reject',               as: 'reject_game'

  post    'max_ranks/new',            to: 'max_ranks#create',           as: 'new_max_rank'
  get     'max_ranks/verify/:id',     to: 'max_ranks#verify',           as: 'verify_max_rank'
  get     'max_ranks/unverify/:id',   to: 'max_ranks#unverify',         as: 'unverify_max_rank'


  post    'votes/new',                to: 'votes#create',               as: 'new_vote'

end
