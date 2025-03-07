import Foundation

public struct PXiCalendar {

  public struct Property: Sendable {
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

    public func asiCalendarString() -> String {
      var result = name

      for (key, value) in parameters {
        result += ";\(key)=\(value)"
      }

      result += ":" + value.formatted()

      return result
    }
  }

  public struct Component: Sendable {
    public let type: ComponentType
    private(set) public var properties: [Property]
    private(set) public var subComponents: [Component]

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

  public enum Value: Sendable {
    case text(String)
    case structuredText(String)
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
      case .structuredText(let string):
        return string
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
        let isNegative = (components.year ?? 0) < 0 ||
        (components.month ?? 0) < 0 ||
        (components.weekOfYear ?? 0) < 0 ||
        (components.day ?? 0) < 0 ||
        (components.hour ?? 0) < 0 ||
        (components.minute ?? 0) < 0 ||
        (components.second ?? 0) < 0

        var result = isNegative ? "-P" : "P"

        let weeks = abs(components.weekOfYear ?? 0)
        let days = abs(components.day ?? 0)
        let hours = abs(components.hour ?? 0)
        let minutes = abs(components.minute ?? 0)
        let seconds = abs(components.second ?? 0)

        if weeks > 0 {
          result += "\(weeks)W"
        } else {
          if days > 0 {
            result += "\(days)D"
          }

          let hasTimeComponents = hours > 0 || minutes > 0 || seconds > 0

          if hasTimeComponents {
            result += "T"

            if hours > 0 {
              result += "\(hours)H"
            }

            if minutes > 0 {
              result += "\(minutes)M"
            }

            if seconds > 0 {
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
