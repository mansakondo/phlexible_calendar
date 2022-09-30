Rails.application.routes.draw do
  root to: "events#index"
  resources :events
  mount PhlexibleCalendar::Engine => "/phlexible_calendar"
end
