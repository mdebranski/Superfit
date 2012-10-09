Superfit::Application.routes.draw do
  get '/models' => 'application#models'
  root :to => 'application#superfit'
end
