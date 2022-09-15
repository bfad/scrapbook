# frozen_string_literal: true

Rails.application.routes.draw do
  extend Scrapbook::Routing

  scrapbook('scrapbook')
end
