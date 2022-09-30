# PhlexibleCalendar
Build custom calendars with Phlex.

:warning: This project is still experimental.

## Motivation
This project started as an experiment to see how we can use [Phlex](https://github.com/joeldrapper/phlex) with [Simple Calendar](https://github.com/excid3/simple_calendar). Then, I realized how it easy it would be to rebuild Simple Calendar with Phlex, as we can
just create a `Phlex::View` instead of using separate files for partials and helpers.

## Usage
This gem works like Simple Calendar. To generate a week calendar, for example, you need a model that responds to `#start_time` and `#end_time`.

Let's scaffold an event resource to demonstrate how it works:
```bash
rails g scaffold event name:string start_time:datetime end_time:datetime
```
```bash
rails db:migrate
```

Now let's start the console and add events:
```ruby
Event.create name: "Interview 1", start_time: Time.now, end_time: Time.now.advance(minutes: 15)
Event.create name: "Interview 2", start_time: Time.now.advance(days: 1, minutes: 15), end_time: Time.now.advance(days: 1, minutes: 30)
Event.create name: "Interview 3", start_time: Time.now.advance(days: 2, minutes: 30), end_time: Time.now.advance(days: 2, minutes: 45)
```

Include `PhlexibleCalendar::Event` in your model:
```ruby
class Event < ApplicationRecord
  include PhlexibleCalendar::Event
end
```

If you need to set the time zone, you can do so in `ApplicationController`:
```ruby
class ApplicationController < ActionController::Base
  before_action :set_time_zone

  private
    def set_time_zone
      session[:time_zone] ||= "Paris"
      Time.zone = session[:time_zone]
    end
end
```

Then, add this in `app/views/events/index.html.erb` to generate a calendar:
```erb
<%= render PhlexibleCalendar::Views::Calendar.new(events: @events) %>
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "phlexible_calendar", github: "mansakondo/phlexible_calendar"
```

Execute:
```bash
$ bundle
```

Mount the engine:
```ruby
Rails.application.routes.draw do
  mount PhlexibleCalendar::Engine => "/phlexible_calendar"
end
```

Add this line in `app/assets/config/manifest.js`:
```js
//= link phlexible_calendar_manifest.js
```

Include the assets in `app/views/layouts/application.html.erb`:
```erb
<%= stylesheet_link_tag "phlexible_calendar/application" %>
<%= javascript_include_tag "phlexible_calendar/application" %>
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
