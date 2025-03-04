import Foundation

public struct PXiCalendar {

  public enum Value {
    case text(String)
    case date(Date)
    case dateTime(Date)
    case duration(DateComponents)
    case integer(Int)
    case calAddress(String)
    case uri(URL)

    public func formatted() -> String {
      switch self {
      case .text(let string):
        return string
          .replacingOccurrences(of: "\n", with: "\\n")
          .replacingOccurrences(of: ";", with: "\\;")
          .replacingOccurrences(of: ",", with: "\\,")
      case .date(let date):
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
      case .dateTime(let date):
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
      case .duration(let components):
        var result = "P"
        if let weeks = components.weekOfYear, weeks > 0 {
          result += "\(weeks)W"
        } else {
          if let days = components.day, days > 0 {
            result += "\(days)D"
          }
          if let hours = components.hour, hours > 0,
             let minutes = components.minute, minutes > 0,
             let seconds = components.second, seconds > 0 {
            result += "T"
            if let hours = components.hour, hours > 0 {
              result += "\(hours)H"
            }
            if let minutes = components.minute, minutes > 0 {
              result += "\(minutes)M"
            }
            if let seconds = components.second, seconds > 0 {
              result += "\(seconds)S"
            }
          }
        }
        return result
      case .integer(let int):
        return "\(int)"
      case .calAddress(let address):
        return "mailto:\(address)"
      case .uri(let url):
        return url.absoluteString
      }
    }
  }

  public struct Property {
    public let name: String
    public let value: Value
    public let parameters: [String: String]

    public init(
      name: String,
      value: Value,
      parameters: [String : String] = [:]
    ) {
      self.name = name
      self.value = value
      self.parameters = parameters
    }

    //TODO: 수정 필요
    public func asiCalendarString() -> String {
      var result = name

      for (key, value) in parameters {
        result += ";\(key)=\(value)"
      }

      result += ":" + value.formatted()

      return result
    }
  }

  public struct Component {
    public let type: ComponentType
    public var properties: [Property]
    public var subComponents: [Component]

    public init(
      type: ComponentType,
      properties: [Property] = [],
      subComponents: [Component] = []
    ) {
      self.type = type
      self.properties = properties
      self.subComponents = subComponents
    }

    public func asiCalendarString() -> String {
      var result = "BEGIN:\(type.rawValue)\r\n"

      for property in properties {
        result += "\(property.asiCalendarString())\r\n"
      }

      for component in subComponents {
        result += component.asiCalendarString()
      }

      result += "END:\(type.rawValue)\r\n"

      return result
    }

    public mutating func add(property: Property) {
      properties.append(property)
    }

    public mutating func add(component: Component) {
      subComponents.append(component)
    }
  }

  public enum ComponentType: String, Sendable {
    case calendar = "VCALENDAR"
    case event = "VEVENT"
    case todo = "VTODO"
    case journal = "VJOURNAL"
    case freebusy = "VFREEBUSY"
    case timezone = "VTIMEZONE"
    case alarm = "VALARM"
    case standard = "STANDARD"
    case daylight = "DAYLIGHT"
  }
}


//BEGIN:VCALENDAR
//VERSION:2.0
//PRODID:-//YourCompany//ShiftDays App//EN
//METHOD:PUBLISH
//BEGIN:VEVENT
//UID:20250304-shift-123456@shiftdays.app
//DTSTAMP:20250304T120000Z
//SUMMARY:일일 근무
//DESCRIPTION:일근
//DTSTART:20250304T100000
//DTEND:20250304T190000
//BEGIN:VALARM
//ACTION:DISPLAY
//DESCRIPTION:일일 근무 시작 알림
//TRIGGER:-PT1H
//END:VALARM
//BEGIN:VALARM
//ACTION:DISPLAY
//DESCRIPTION:일일 근무 시작 알림
//TRIGGER:-P1D
//END:VALARM
//END:VEVENT
//END:VCALENDAR
