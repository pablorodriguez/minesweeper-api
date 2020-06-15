Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'minesweepers#index'

  resources :minesweepers do
    member do
      patch :click
    end
  end

end
