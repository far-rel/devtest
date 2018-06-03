Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root controller: :pages, action: :root

  get 'locations/:country_code', to: 'locations#show'
  get 'target_groups/:country_code', to: 'target_groups#show'
  post 'evaluate_target', to: 'target_groups#evaluate'

end
