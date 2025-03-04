# PXiCalendar
A Swift library for creating and managing iCalendar (RFC 5545) formatted events

## Installation

### Swift Package Manager

PXiCalendar can be installed using Swift Package Manager. Add it to your project by following these steps:

1. In Xcode, select **File** > **Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/pixohq/PXiCalendar`
3. Choose the version or branch you want to use
4. Click **Add Package**

Alternatively, you can add it directly to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/pixohq/PXiCalendar", .upToNextMajor(from: "1.0.0"))
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["PXiCalendar"]),
]

```

## Basic Usage

### Creating a Calendar

```swift
import PXiCalendar

// Create a new calendar
var calendar = PXiCalendar.Calendar()

// Add custom properties (optional)
calendar.add(property: .init(
    name: PXiCalendar.PXCalendar.name.rawValue,
    value: .text("My Calendar")
))

```

### Creating an Event

```swift
// Create an event component
var event = PXiCalendar.Component(type: .event)

// Add required properties
let now = Date()
event.add(property: .init(
    name: PXiCalendar.PXEvent.uid.rawValue,
    value: .text(UUID().uuidString)
))
event.add(property: .init(
    name: PXiCalendar.PXEvent.dtstamp.rawValue,
    value: .dateTime(now)
))
event.add(property: .init(
    name: PXiCalendar.PXEvent.dtstart.rawValue,
    value: .dateTime(now),
    parameters: ["TZID": TimeZone.current.identifier]
))

// Add event summary and description
event.add(property: .init(
    name: PXiCalendar.PXEvent.summary.rawValue,
    value: .text("Team Meeting")
))
event.add(property: .init(
    name: PXiCalendar.PXEvent.description.rawValue,
    value: .text("Weekly project status update")
))

```

### Adding a Recurring Rule

```swift
// Create a weekly recurring event (every Monday, Wednesday, Friday)
let weekdays = [PXiCalendar.Weekday.monday, .wednesday, .friday]
let recurrenceRule = PXiCalendar.RecurrenceRule(
    recurrence: .weekly,
    until: Calendar.current.date(byAdding: .month, value: 3, to: Date()),
    byDay: weekdays
)

// Add the rule to the event
event.add(property: .init(
    name: PXiCalendar.PXEvent.rrule.rawValue,
    value: .structuredText(recurrenceRule.formatted())
))

```

### Adding an Alarm

```swift
// Create an alarm component for 15 minutes before the event
var alarm = PXiCalendar.Component(type: .alarm)

// Set alarm action type
alarm.add(property: .init(
    name: PXiCalendar.PXAlarm.action.rawValue,
    value: .text(PXiCalendar.AlarmAction.display.rawValue)
))

// Set trigger time (15 minutes before)
alarm.add(property: .init(
    name: PXiCalendar.PXAlarm.trigger.rawValue,
    value: .duration(DateComponents(minute: -15))
))

// Add description
alarm.add(property: .init(
    name: PXiCalendar.PXAlarm.description.rawValue,
    value: .text("Meeting starts in 15 minutes")
))

// Add the alarm to the event
event.add(component: alarm)

```

### Finalizing the Calendar

```swift
// Add the event to the calendar
calendar.add(component: event)

// Generate iCalendar formatted string
let iCalString = calendar.asiCalendarString()
print(iCalString)

```

## Advanced Usage

### Creating Events with Duration

```swift
// Set event duration instead of end time
let durationComponents = DateComponents(hour: 1, minute: 30)
event.add(property: .init(
    name: PXiCalendar.PXEvent.duration.rawValue,
    value: .duration(durationComponents)
))

```

### Complex Recurrence Rules

```swift
// Monthly meeting on the first Monday of each month
let recurrenceRule = PXiCalendar.RecurrenceRule(
    recurrence: .monthly,
    count: 12,  // For 12 months
    byDay: [.monday],
    bySetPos: [1]  // First occurrence
)

```

### Creating Tasks (TODOs)

```swift
// Create a TODO component
var todo = PXiCalendar.Component(type: .todo)
todo.add(property: .init(
    name: PXiCalendar.PXEvent.uid.rawValue,
    value: .text(UUID().uuidString)
))
todo.add(property: .init(
    name: PXiCalendar.PXEvent.dtstamp.rawValue,
    value: .dateTime(Date())
))
todo.add(property: .init(
    name: PXiCalendar.PXEvent.summary.rawValue,
    value: .text("Complete project documentation")
))

// Add the TODO to calendar
calendar.add(component: todo)

```

## Compatibility

PXiCalendar generates standard iCalendar format files compatible with:

- Apple Calendar
- Google Calendar
- Microsoft Outlook
- Mozilla Thunderbird
- And most other calendar applications that support the iCalendar (RFC 5545) standard
