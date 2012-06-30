Superfit::Application.routes.draw do
  get '/mobile' => 'application#mobile'
  get '/jqm' => 'application#jqm'
  get '/models' => 'application#models'

  root :to => 'application#index'
end
