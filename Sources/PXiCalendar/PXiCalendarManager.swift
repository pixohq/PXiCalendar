import Foundation


public class PXiCalendarManager {
  @MainActor public static let shared = PXiCalendarManager()

  private let fileManager = FileManager.default
  private init() {}

  private func calendarDirectoryURL() throws -> URL {
    let documentsDirectory = try fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )
    let calendarDirectory = documentsDirectory.appendingPathComponent("Calendars", isDirectory: true)

    if !fileManager.fileExists(atPath: calendarDirectory.path) {
      try fileManager.createDirectory(at: calendarDirectory,
                                      withIntermediateDirectories: true,
                                      attributes: nil)
    }

    return calendarDirectory
  }

  private func calendarFileURL(calendarID: String) throws -> URL {
    let directory = try calendarDirectoryURL()
    return directory.appendingPathComponent("\(calendarID).ics")
  }

  public func createCalendar(
    calendarID: String,
    name: String? = nil,
    method: PXiCalendar.CalendarMethod = .publish
  ) throws -> PXiCalendar.Calendar {
      var calendar = PXiCalendar.Calendar()

      // 캘린더 이름 설정 (선택적)
      if let name = name {
        calendar.add(property: PXiCalendar.Property(
          name: PXiCalendar.PXCalendar.name.rawValue,
          value: .text(name)
        ))
      }

      // 메소드 설정
      calendar.add(property: PXiCalendar.Property(
          name: PXiCalendar.PXCalendar.method.rawValue,
          value: .text(method.rawValue)
      ))

      // 캘린더 고유 ID 설정
      calendar.add(property: PXiCalendar.Property(
          name: PXiCalendar.PXCalendar.uid.rawValue,
          value: .text(calendarID)
      ))

      // 파일에 저장
      try saveCalendarToFile(calendar: calendar, calendarID: calendarID)

      return calendar
  }

  private func saveCalendarToFile(calendar: PXiCalendar.Calendar, calendarID: String) throws {
    let fileURL = try calendarFileURL(calendarID: calendarID)
    let content = calendar.asiCalendarString()
    try content.write(to: fileURL, atomically: true, encoding: .utf8)
  }
}
