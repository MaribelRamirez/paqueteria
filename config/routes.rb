Rails.application.routes.draw do
  get 'principal/index'
  get 'principal' => 'principal#index'
  root 'principal#index'

  get "principal/buscar"
  post "principal/buscar"
  get "principal/index2"
  post "principal/index2"
  post "principal/buscar_json"
  get "principal/buscar_json"

end
