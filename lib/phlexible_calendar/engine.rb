require "phlex"

module PhlexibleCalendar
  class Engine < ::Rails::Engine
    isolate_namespace PhlexibleCalendar

    config.autoload_paths << File.expand_path("app/views/", "../../")
  end
end
