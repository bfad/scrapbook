# frozen_string_literal: true

Rails.application.routes.draw do
  mount Scrapbook::Engine => '/scrapbook'
end
