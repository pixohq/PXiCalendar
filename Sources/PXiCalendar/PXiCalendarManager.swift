import Foundation

public actor PXiCalendarManager {
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

  private func saveCalendarToFile(calendar: PXiCalendar.Calendar, calendarID: String) throws {
    let fileURL = try calendarFileURL(calendarID: calendarID)
    let content = calendar.asiCalendarString()
    try content.write(to: fileURL, atomically: true, encoding: .utf8)
  }
}
