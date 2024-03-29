Rails.application.routes.draw do
  get '/dashboard', to: 'dashboard#index'

  resources :clusters, only: [:index, :show]

  post '/watcher/clusters/:cluster_id/nodes/:node_id', to: 'watcher#update'

  root to: 'docs#index'
  get '/tutorial', to: 'docs#tutorial'

  post '/agent/api', to: 'agent#register_cluster_node'
  # POST /api is legacy
  post '/api', to: 'agent#register_cluster_node'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
