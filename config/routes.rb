Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations:      'users/registrations',
    sessions:           'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  devise_scope :user do
    get 'index',                    to: 'users/registrations#index'
    get 'phones',                   to: 'users/registrations#new_phone'
    post 'phones',                  to: 'users/registrations#create_phone'
    get 'addresses',                to: 'users/registrations#new_address'
    post 'addresses',               to: 'users/registrations#create_address'
    get 'cards',                    to: 'users/registrations#new_card'
    post 'cards',                   to: 'users/registrations#create_card'
    get 'users/login',              to: 'users/sessions#new'
    get 'users/done',               to: 'users/registrations#done'
  end

  get 'comments/new',               to: 'comments#new'
  get 'layouts/footer',             to: 'layouts#footer'
  get 'layouts/application',        to: 'layouts#application'
  get 'layouts/mailer',             to: 'layouts#mailer'
  get 'layouts/mailer.text',        to: 'layouts#mailer.text'

  get 'posts/menu',                 to: 'posts#menu'

  get 'products/exhibition_page',   to: 'products#exhibition_page'
  get 'search',                     to: 'products#search'

  get 'users/editdata',             to: 'users#editdata'
  get 'users/show',                 to: 'users#show'
  get 'users/identity_information', to: 'users#identity_information'
  
  get 'users/logout', to: 'users#logout'
  get 'users/payment_method', to: 'users#payment_method'

  resources :products do
    resources :users, only: :new
  end
  
  root 'products#index'
    resources :products do
    get 'order', to: 'products#order'
    get 'pay', to: 'products#pay'
    get 'complete', to: 'products#complete'
    post 'update', to: 'products#update'
  end
end