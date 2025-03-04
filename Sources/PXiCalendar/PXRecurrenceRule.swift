
import Foundation

extension PXiCalendar {
  public enum Recurrence: String {
    case daily = "DAILY"
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
    case yearly = "YEARLY"
  }

  public enum Weekday: String {
    case sunday = "SU"
    case monday = "MO"
    case tuesday = "TU"
    case wednesday = "WE"
    case thursday = "TH"
    case friday = "FR"
    case saturday = "SA"
  }

  public struct RecurrenceRule {
    public let recurrence: Recurrence
    public var interval: Int?
    public var count: Int?
    public var until: Date?
    public var byDay: [Weekday]?
    public var byMonthDay: [Int]?
    public var byYearDay: [Int]?
    public var byWeekNo: [Int]?
    public var byMonth: [Int]?
    public var bySetPos: [Int]?
    public var weekStart: Weekday?

    public init(
      recurrence: Recurrence,
      interval: Int? = nil,
      count: Int? = nil,
      until: Date? = nil,
      byDay: [Weekday]? = nil,
      byMonthDay: [Int]? = nil,
      byYearDay: [Int]? = nil,
      byWeekNo: [Int]? = nil,
      byMonth: [Int]? = nil,
      bySetPos: [Int]? = nil,
      weekStart: Weekday? = nil
    ) {
      self.recurrence = recurrence
      self.interval = interval
      self.count = count
      self.until = until
      self.byDay = byDay
      self.byMonthDay = byMonthDay
      self.byYearDay = byYearDay
      self.byWeekNo = byWeekNo
      self.byMonth = byMonth
      self.bySetPos = bySetPos
      self.weekStart = weekStart
    }

    public func formatted() -> String {
      var parts = ["FREQ=\(recurrence.rawValue)"]

      if let interval = interval {
        parts.append("INTERVAL=\(interval)")
      }

      if let count = count {
        parts.append("COUNT=\(count)")
      }

      if let until = until {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        parts.append("UNTIL=\(formatter.string(from: until))")
      }

      if let byDay = byDay, !byDay.isEmpty {
        let daysString = byDay.map { $0.rawValue }.joined(separator: ",")
        parts.append("BYDAY=\(daysString)")
      }

      if let byMonthDay = byMonthDay, !byMonthDay.isEmpty {
        let daysString = byMonthDay.map { String($0) }.joined(separator: ",")
        parts.append("BYMONTHDAY=\(daysString)")
      }

      if let byYearDay = byYearDay, !byYearDay.isEmpty {
        let daysString = byYearDay.map { String($0) }.joined(separator: ",")
        parts.append("BYYEARDAY=\(daysString)")
      }

      if let byWeekNo = byWeekNo, !byWeekNo.isEmpty {
        let weeksString = byWeekNo.map { String($0) }.joined(separator: ",")
        parts.append("BYWEEKNO=\(weeksString)")
      }

      if let byMonth = byMonth, !byMonth.isEmpty {
        let monthsString = byMonth.map { String($0) }.joined(separator: ",")
        parts.append("BYMONTH=\(monthsString)")
      }

      if let bySetPos = bySetPos, !bySetPos.isEmpty {
        let posString = bySetPos.map { String($0) }.joined(separator: ",")
        parts.append("BYSETPOS=\(posString)")
      }

      if let weekStart = weekStart {
        parts.append("WKST=\(weekStart.rawValue)")
      }

      return parts.joined(separator: ";")
    }
  }
}
