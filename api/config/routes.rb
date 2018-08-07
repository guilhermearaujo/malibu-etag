Rails.application.routes.draw do
  get :endpoint, controller: :application, action: :endpoint
end
