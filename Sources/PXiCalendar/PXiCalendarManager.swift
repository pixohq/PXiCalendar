import Foundation

public actor PXiCalendarManager {
  private let fileManager = FileManager.default

  public static let shared = PXiCalendarManager()

  private init() {}

  public func createCalendar(
    calendarName: String,
    calendarDescription: String? = nil,
    eventTitle: String,
    eventDescription: String? = nil,
    eventLocation: String? = nil,
    eventStartDate: Date,
    eventEndDate: Date,
    eventIsAllDay: Bool = false,
    eventRecurrenceRule: PXiCalendar.RecurrenceRule?
  ) -> PXiCalendar.Calendar {
    var calendar = PXiCalendar.Calendar()

    if !calendarName.isEmpty {
      calendar.add(property: PXiCalendar.Property(
        name: PXiCalendar.PXCalendar.name.rawValue,
        value: .text(calendarName)
      ))
    }

    if let calendarDescription, !calendarDescription.isEmpty {
      calendar.add(property: PXiCalendar.Property(
        name: PXiCalendar.PXCalendar.description.rawValue,
        value: .text(calendarDescription)
      ))
    }

    //TODO: EventConfiguration
    let event = createEvent(
      title: eventTitle,
      description: eventDescription,
      location: eventLocation,
      startDate: eventStartDate,
      endDate: eventEndDate,
      isAllDay: eventIsAllDay,
      recurrenceRule: eventRecurrenceRule
    )

    calendar.add(component: event)

    return calendar
  }

  public func createEvent(
    title: String,
    description: String? = nil,
    location: String? = nil,
    startDate: Date,
    endDate: Date,
    isAllDay: Bool = false,
    recurrenceRule: PXiCalendar.RecurrenceRule?
  ) -> PXiCalendar.Component {
    var event = PXiCalendar.Component(type: .event)

    let eventUID = UUID().uuidString
    let currentDate = Date()

    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.uid.rawValue,
      value: .text(eventUID)
    ))

    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.dtstamp.rawValue,
      value: .dateTime(currentDate)
    ))

    let valueType: PXiCalendar.Value = isAllDay ? .date(startDate) : .dateTime(startDate)
    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.dtstart.rawValue,
      value: valueType,
      parameters: isAllDay ? [:] : ["TZID": TimeZone.current.identifier]
    ))

    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.dtend.rawValue,
      value: isAllDay ? .date(endDate) : .dateTime(endDate),
      parameters: isAllDay ? [:] : ["TZID": TimeZone.current.identifier]
    ))

    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.summary.rawValue,
      value: .text(title)
    ))

    if let description = description, !description.isEmpty {
      event.add(property: PXiCalendar.Property(
        name: PXiCalendar.PXEvent.description.rawValue,
        value: .text(description)
      ))
    }

    if let location = location, !location.isEmpty {
      event.add(property: PXiCalendar.Property(
        name: PXiCalendar.PXEvent.location.rawValue,
        value: .text(location)
      ))
    }

    if let recurrenceRule {
      event.add(
        property: PXiCalendar.Property(
          name: PXiCalendar.PXEvent.rrule.rawValue,
          value: .structuredText(recurrenceRule.formatted())
        )
      )
    }

    return event
  }

  public func createShareURL(for calendar: PXiCalendar.Calendar) throws -> URL {
    let tempDirectoryURL = fileManager.temporaryDirectory
    let filename = "event-\(Date()).ics"
    let fileURL = tempDirectoryURL.appendingPathComponent(filename)

    let content = calendar.asiCalendarString()
    try content.write(to: fileURL, atomically: true, encoding: .utf8)

    return fileURL
  }
}
