Rails.application.routes.draw do
  root to: 'docs#index'
  get '/tutorial', to: 'docs#tutorial'

  post '/agent/api', to: 'agent#register_cluster_node'
  # POST /api is legacy
  post '/api', to: 'agent#register_cluster_node'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
