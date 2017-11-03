Rails.application.routes.draw do
  devise_for :administrators
	root 'users#submit_code'
	get 'form' => 'users#submit_code', as: :users_root
	post 'form' => 'users#post_user', as: :post_user

	get 'form/:code' => "users#form", as: :users_form
  patch 'form/:code' => "users#update"

  get 'form/:code/submit' => "users#submitted", as: :users_submit
  get 'form/:code/completed' => 'users#completed', as: :users_completed
	resource :users

	namespace :admin do
		resources :api_settings
		resources :attendee_reports do
			get 'attendee_reports' => "attendee_reports#show", as: :all_reports
		end
		resources :users do
			post '/sync_paperless', on: :member, to: 'users#sync_paperless'
		end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
