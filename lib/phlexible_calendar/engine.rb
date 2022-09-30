require "phlex"
require "rounding"

module PhlexibleCalendar
  class Engine < ::Rails::Engine
    isolate_namespace PhlexibleCalendar

    config.autoload_paths << File.expand_path("lib/", "#{__dir__}/../../")
    config.autoload_paths << File.expand_path("app/views/", "#{__dir__}/../../")
  end
end
