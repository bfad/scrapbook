# frozen_string_literal: true

Scrapbook::Engine.routes.draw do
  # TODO: Future plans
  # scope path: '/.editor' do
  #   resources :pages, id: /.+/, only: %i[new create edit update]
  # end

  root 'pages#show'

  get '.raw/pages(/*id)', to: 'pages#raw', constraints: {id: /.*/}, as: :raw_page
  get '*id', to: 'pages#show', constraints: {id: /.*/}, as: :short_page
end
