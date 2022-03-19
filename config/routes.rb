Scrapbook::Engine.routes.draw do
  resources :pages, id: /.+/
end
