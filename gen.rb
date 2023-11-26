require 'icalendar'
require 'json'

events = JSON.parse File.read 'docs/2023.json'
cal = Icalendar::Calendar.new

events.each do |event_data|
  event_date = Date.parse(event_data['date'])
  start_time = DateTime.parse("#{event_date} #{event_data['start_time']}")
  end_time = DateTime.parse("#{event_date} #{event_data['end_time']}")
  created_time = DateTime.parse("#{event_date} #{event_data['createdAt']}")
  updated_time = DateTime.parse("#{event_date} #{event_data['updatedAt']}")

  # Create an event within the calendar
  cal.event do |e|
    e.uid = event_data['id']
    e.dtstart     = Icalendar::Values::DateTime.new(start_time, 'tzid' => "Asia/Kolkata")
    e.dtend       = Icalendar::Values::DateTime.new(end_time, 'tzid' => "Asia/Kolkata")
    e.created     = Icalendar::Values::DateTime.new(created_time, 'tzid' => "Asia/Kolkata")
    e.last_modified     = Icalendar::Values::DateTime.new(updated_time, 'tzid' => "Asia/Kolkata")
    e.summary     = event_data['event_name']

    if event_data['thumbnail'] =~ /https:\/\/drive.google.com\/file\/d\/([a-zA-Z0-9\-]+)/
      e.append_attach   Icalendar::Values::Uri.new("https://drive.google.com/uc?id=#{$1}", "fmttype" => "image/png")
    end

    e.description = " \
      Location Link: #{event_data['gmap_coordinates']}
      This is a #{event_data['ticketType']} event.
      #{event_data['category']} - #{event_data['sub_category']}
    "

    if event_data['book_bms_link'] != "" and event_data['book_bms_link'] != event_data['knowMore_url']
      e.description += "More Details: #{event_data['knowMore_url']}"
    end
    e.location    = event_data['venue'] + " / #{event_data['regions']} Bangalore"
    url = ""
    for url_key in ['book_bms_link', 'knowMore_url', 'gmap_coordinates']
      url = url.empty? ? event_data[url_key] : url
    end
    e.url         = url
  end
end

cal.publish
File.write 'docs/2023.ics', cal.to_ical