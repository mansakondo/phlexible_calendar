module PhlexibleCalendar::Event
  extend ActiveSupport::Concern

  included do
    def duration_in_quarter_hours
      seconds = (end_time - start_time).to_i
      minutes = seconds / 60
      minutes / 15
    end

    def height_in_percentage
      25 * duration_in_quarter_hours
    end
  end
end
