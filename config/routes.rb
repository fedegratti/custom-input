Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  get  "/install",        to: "oauth#install"   # opcional: link para instalar
  get  "/oauth/callback", to: "oauth#callback"

  # endpoint que servirá el JS a inyectar
  get  "/inject.js", to: "scripts#inject", defaults: { format: :js }

  # acción para registrar el script en la tienda
  post "/scripts/register/:id", to: "scripts#register", as: :register_script
end
