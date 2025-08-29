Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  # Onboarding routes
  namespace :onboarding do
    resources :tutors, only: [:new, :create]
    resources :students, only: [:new, :create]
  end

  # Profile context switching
  patch "profile_session", to: "profile_sessions#update"

  # Dashboard routes
  get "tutor/dashboard", to: "tutors/dashboard#show", as: :tutor_dashboard
  get "student/dashboard", to: "students/dashboard#show", as: :student_dashboard

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
