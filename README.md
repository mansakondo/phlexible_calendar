# PhlexibleCalendar
Build custom calendars with Phlex.

:warning: This project is still experimental.

## Motivation
This project started as an experiment to see how we can use [Phlex](https://github.com/joeldrapper/phlex) with [Simple Calendar](https://github.com/excid3/simple_calendar). Then, I realized how easy it would be to rebuild Simple Calendar with Phlex, as we can
just create a `Phlex::View` instead of using separate files for partials and helpers.

## Usage
### Getting started
This gem works like [Simple Calendar](https://github.com/excid3/simple_calendar). To generate a calendar, you need a model that responds to `#start_time` and `#end_time` (but you can use [custom attributes](#custom-attributes)).

Let's scaffold an event resource to demonstrate how it works:
```bash
rails g scaffold event name:string start_time:datetime end_time:datetime
```
```bash
rails db:migrate
```

Now let's seed some events:
```ruby
# db/seeds.rb
Event.create name: "Interview 1", start_time: Time.now, end_time: Time.now.advance(minutes: 15)
Event.create name: "Interview 2", start_time: Time.now.advance(days: 1, minutes: 15), end_time: Time.now.advance(days: 1, minutes: 45)
Event.create name: "Interview 3", start_time: Time.now.advance(days: 2, minutes: 30), end_time: Time.now.advance(days: 2, minutes: 75)
```

```bash
rails db:seed
```

Include `PhlexibleCalendar::Event` in your model:
```ruby
class Event < ApplicationRecord
  include PhlexibleCalendar::Event
end
```

Then, add this in `app/views/events/index.html.erb` to generate a calendar:
```erb
<%= render PhlexibleCalendar::Views::Calendar.new(events: @events) %>
```

### Custom attributes
```ruby
class Event < ApplicationRecord
  include PhlexibleCalendar::Event

  def start_attribute
    :start
  end

  def end_attribute
    :end
  end
end
```

```erb
<%= render PhlexibleCalendar::Views::Calendar.new(events: @events, start_attribute: :start, end_attribute: :end) %>
```

### Time zones
You need to set `session[:time_zone]` to specify the time zone per request:
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

## Installation
Add this line to your application's Gemfile:

```ruby
gem "phlexible_calendar", github: "mansakondo/phlexible_calendar"
```

Execute:
```bash
$ bundle
```

Then, run the installer:
```bash
rails phlexible_calendar:install
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
