# frozen_string_literal: true

Scrapbook::Engine.routes.draw do
  book_regex = /#{Scrapbook::Engine.config.scrapbook.paths.map { File.basename(_1) }.join('|')}/

  resources :pages, id: /.+/

  resources :pages, path: ':book/pages', id: /.+/, constraints: {book: book_regex}

  get ':book/*id', to: 'pages#show', constraints: {book: book_regex}
  get '*id', to: 'pages#show', constraints: {id: /.*/}, as: :short_page
end
