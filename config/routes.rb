# frozen_string_literal: true

Scrapbook::Engine.routes.draw do
  resources :pages, id: /.+/
end
