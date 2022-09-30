module PhlexibleCalendar
  module Views
    class Calendar < ApplicationView
      HOURS = [
        "",
        "1 AM",
        "2 AM",
        "3 AM",
        "4 AM",
        "5 AM",
        "6 AM",
        "7 AM",
        "8 AM",
        "9 AM",
        "10 AM",
        "11 AM",
        "12 AM",
        "1 PM",
        "2 PM",
        "3 PM",
        "4 PM",
        "5 PM",
        "6 PM",
        "7 PM",
        "8 PM",
        "9 PM",
        "10 PM",
        "11 PM",
        "12 PM"
      ].freeze

      PARAM_KEY_BLACKLIST = :authenticity_token, :commit, :utf8, :_method, :script_name

      delegate_missing_to :helpers

      attr_reader :options, :events

      def initialize(**options)
        @options = options
        @events = options.fetch(:events, [])
        @params = respond_to?(:params) ? params : {}
        @params = @params.to_unsafe_h if @params.respond_to?(:to_unsafe_h)
        @params = @params.with_indifferent_access.except(*PARAM_KEY_BLACKLIST)
      end

      def template(&block)
        div class: "flex justify-center" do
          div class: "flex flex-col", data: { controller: "calendar-component" } do
            div class: "flex ml-16 py-8"do
              date_range.slice(0, 7).each do |day|
                span class: "text-md text-center text-gray-600 w-[160px]" do
                  t("date.abbr_day_names")[day.wday]
                end
              end
            end

            div class: "overflow-auto h-[540px]" do
              div class: "flex" do
                div class: "flex flex-col w-16" do
                  HOURS.each_with_index do |hour, i|
                    div class: "relative h-14" do
                      span class: "absolute bottom-12 text-xs text-gray-600" do
                        hour
                      end
                    end
                  end
                end

                date_range.slice(0, 7).each do |day|
                  div class: "relative flex flex-col w-[160px]" do
                    times_for_quarter_hours(day).each_slice(4) do |times|
                      div class: "relative h-14 border" do
                        times.each_with_index do |time, i|
                          div class: "w-full", style: "height: 25%; top: #{25*i}%;", data: { time: time } do
                            if block_given?
                              block.call time, sorted_events.fetch(time, nil)
                            else
                              if (event = sorted_events.fetch(time, nil))
                                div id: event.start_time, class: "absolute flex justify-center items-center w-full bg-gray-900 text-white text-xs z-10 rounded", style: "height: #{event.height_in_percentage}%;", draggable: true do
                                  a href: event_path(event.id) do
                                    span do
                                      event.name
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end

            div class: "flex justify-around items-center mt-4" do
              a href: url_for_previous_view, class: "flex justify-center items-center h-10 w-10 bg-gray-900 text-white rounded-full " do
                t("simple_calendar.previous", default: "<")
              end

              a href: url_for_next_view, class: "flex justify-center items-center h-10 w-10 bg-gray-900 text-white rounded-full " do
                t("simple_calendar.next", default: ">")
              end
            end
          end
        end
      end

      private
      def url_for_next_view
        url_for(@params.merge(start_date_param => (date_range.last + 1.day).iso8601))
      end

      def url_for_previous_view
        url_for(@params.merge(start_date_param => (date_range.first - 1.day).iso8601))
      end

      def date_range
        (start_date.beginning_of_week..start_date.end_of_week).to_a
      end

      def attribute
        options.fetch(:attribute, :start_time).to_sym
      end

      def end_attribute
        options.fetch(:end_attribute, :end_time).to_sym
      end

      def start_date_param
        options.fetch(:start_date_param, :start_date).to_sym
      end

      def sorted_events
        @sorted_events ||=
          begin
            events = options.fetch(:events, []).reject { |e| e.send(attribute).nil? }.sort_by(&attribute)
            index_events_by_time(events)
          end
      end

      def group_events_by_date(events)
        events_grouped_by_date = Hash.new { |h, k| h[k] = [] }

        events.each do |event|
          event_start_date = event.send(attribute).to_date
          event_end_date = event.respond_to?(end_attribute) && !event.send(end_attribute).nil? ? event.send(end_attribute).to_date : event_start_date
          (event_start_date..event_end_date.to_date).each do |enumerated_date|
            events_grouped_by_date[enumerated_date] << event
          end
        end

        events_grouped_by_date
      end

      def index_events_by_time(events)
        events.each_with_object({}) do |event, indexed_by_time|
          indexed_by_time[event.start_time.round_to(15.minutes)] = event
        end
      end

      def start_date
        if options.has_key?(:start_date)
          options.fetch(:start_date).to_date
        else
          params.fetch(start_date_param, Date.current).to_date
        end
      end

      def end_date
        date_range.last
      end

      def additional_days
        options.fetch(:number_of_days, 7) - 1
      end

      def times_for_quarter_hours(day)
        time_zone = session[:time_zone]
        times = (0..23).to_a.each_with_object([day.beginning_of_day.in_time_zone(time_zone)]) do |_hours, times|
          4.times do
            time = times.last
            times << time.advance(minutes: 15)
          end
        end

        times.pop
        times
      end
    end
  end
end
