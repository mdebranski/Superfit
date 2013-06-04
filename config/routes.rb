Superfit::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  scope :path => 'api' do
    resources :gyms
  end

  root :to => 'application#superfit'
end
