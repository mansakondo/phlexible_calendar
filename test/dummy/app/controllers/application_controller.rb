class ApplicationController < ActionController::Base
  before_action :set_time_zone

  private
    def set_time_zone
      session[:time_zone] ||= "Paris"
      Time.zone = session[:time_zone]
    end
end
