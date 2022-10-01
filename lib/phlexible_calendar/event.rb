module PhlexibleCalendar::Event
  extend ActiveSupport::Concern

  included do
    def duration_in_quarter_hours
      seconds = (public_send(end_attribute) - public_send(start_attribute)).to_i
      minutes = seconds / 60
      minutes / 15
    end

    def height_in_percentage
      25 * duration_in_quarter_hours
    end

    def start_attribute
      :start_time
    end

    def end_attribute
      :end_time
    end
  end
end
