require 'icalendar'
require 'json'

data = JSON.parse File.read '_site/2023.json'
events = data['events']
cal = Icalendar::Calendar.new

events.each do |event_data|
  event_date = Date.parse(event_data['date'])
  start_time = DateTime.parse("#{event_date} #{event_data['start_time']}")
  end_time = DateTime.parse("#{event_date} #{event_data['end_time']}")

  # Create an event within the calendar
  cal.event do |e|
    e.dtstart     = Icalendar::Values::DateTime.new(start_time, 'tzid' => "Asia/Kolkata")
    e.dtend       = Icalendar::Values::DateTime.new(end_time, 'tzid' => "Asia/Kolkata")
    e.summary     = event_data['event_name']


    e.description = " \
      Location Link: #{event_data['gmap_coordinates']}
      This is a #{event_data['ticketType']} event.
      #{event_data['category']} - #{event_data['sub_category']}
    "

    if event_data['book_bms_link'] != "" and event_data['book_bms_link'] != event_data['knowMore_url']
      e.description += "More Details: #{event_data['knowMore_url']}"
    end
    e.location    = event_data['venue']
    url = ""
    for url_key in ['book_bms_link', 'knowMore_url', 'gmap_coordinates']
      url = url.empty? ? event_data[url_key] : url
    end
    e.url         = url
  end
end

cal.publish
File.write '2023.ics', cal.to_ical