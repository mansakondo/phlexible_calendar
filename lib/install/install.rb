say "Add assets in the asset pipeline"
empty_directory "vendor/assets/phlexible_calendar"
copy_file "#{__dir__}/../../app/assets/builds/phlexible_calendar/application.css", "vendor/assets/phlexible_calendar/application.css"
copy_file "#{__dir__}/../../app/assets/builds/phlexible_calendar/application.js", "vendor/assets/phlexible_calendar/application.js"

if (app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")).exist?
  say "Add stylesheet link tag in application layout"
  insert_into_file app_layout_path.to_s,
    %(\n    <%= stylesheet_link_tag "phlexible_calendar/application", defer: true %>), before: /\s*<\/head>/

  say "Add JavaScript include tag in application layout"
  insert_into_file app_layout_path.to_s,
    %(\n    <%= javascript_include_tag "phlexible_calendar/application", defer: true %>), before: /\s*<\/head>/
end

if (manifest_path = Rails.root.join("app/assets/config/manifest.js"))
  say "Declare assets in the manifest"
  insert_into_file manifest_path.to_s,
    %(//= link phlexible_calendar_manifest.js)
end
