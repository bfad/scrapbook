# frozen_string_literal: true

Scrapbook::Engine.routes.draw do
  book_regex = /#{Scrapbook::Engine.config.scrapbook.paths.map { File.basename(_1) }.join('|')}/

  resources :pages, id: /.+/
  resources :pages, path: ':book/pages', id: /.+/, constraints: {book: book_regex}

  get ':book', to: 'pages#index', constraints: {book: book_regex}
  root 'pages#index'

  get '.raw/:book/pages/*id', to: 'pages#raw', as: :raw_page,
    constraints: {book: book_regex, id: /.*/}, defaults: {raw: true}
  get ':book/*id', to: 'pages#show', constraints: {book: book_regex, id: /.*/}
  get '*id', to: 'pages#show', constraints: {id: /.*/}, as: :short_page
end
