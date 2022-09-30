require_relative "lib/phlexible_calendar/version"

Gem::Specification.new do |spec|
  spec.name        = "phlexible_calendar"
  spec.version     = PhlexibleCalendar::VERSION
  spec.authors     = ["mansakondo"]
  spec.email       = ["mansakondo22@gmail.com"]
  spec.homepage    = "https://github.com/mansakondo/phlexible_calendar"
  spec.summary     = "Build custom calendars with Phlex"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.1"
  spec.add_dependency "phlex", ">= 0.3.0"
end
