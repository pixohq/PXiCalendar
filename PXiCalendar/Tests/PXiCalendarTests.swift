//
//  PXiCalendarTests.swift
//  PXiCalendar
//
//  Created by 한지석 on 3/4/25.
//

import XCTest
@testable import PXiCalendar

final class PXiCalendarTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testCreateEvent() {
    var calendar = PXiCalendar.Calendar()
    let event1 = createShiftDaysEvent()
    let event2 = createShiftDaysEvent()
    calendar.add(component: event1)
    calendar.add(component: event2)
    print(calendar.asiCalendarString())
    XCTAssertTrue(calendar.components.count == 2)
  }

  func createShiftDaysEvent() -> PXiCalendar.Component {
    let calendar = Calendar.current
    let startDate = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
    let endDate = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!

    // 이벤트 생성
    var event = PXiCalendar.Component(type: .event)

    // 기본 속성
    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.uid.rawValue,
      value: .text(UUID().uuidString)
    ))

    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.dtstamp.rawValue,
      value: .dateTime(Date())
    ))

    // 제목 및 설명
    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.summary.rawValue,
      value: .text("일일 근무")
    ))

    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.description.rawValue,
      value: .text("일근")
    ))

    // 시작 및 종료 시간
    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.dtstart.rawValue,
      value: .dateTime(startDate)
    ))

    event.add(property: PXiCalendar.Property(
      name: PXiCalendar.PXEvent.dtend.rawValue,
      value: .dateTime(endDate)
    ))

    // 알람1: 1시간 전
    var alarm1 = PXiCalendar.Component(type: .alarm)
    alarm1.add(property: PXiCalendar.Property(
      name: "ACTION",
      value: .text("DISPLAY")
    ))

    var trigger1 = DateComponents()
    trigger1.hour = -1

    alarm1.add(property: PXiCalendar.Property(
      name: "TRIGGER",
      value: .duration(trigger1)
    ))

    alarm1.add(property: PXiCalendar.Property(
      name: "DESCRIPTION",
      value: .text("일일 근무 시작 알림")
    ))

    // 알람2: 1일 전
    var alarm2 = PXiCalendar.Component(type: .alarm)
    alarm2.add(property: PXiCalendar.Property(
      name: "ACTION",
      value: .text("DISPLAY")
    ))

    var trigger2 = DateComponents()
    trigger2.day = -1

    alarm2.add(property: PXiCalendar.Property(
      name: "TRIGGER",
      value: .duration(trigger2)
    ))

    alarm2.add(property: PXiCalendar.Property(
      name: "DESCRIPTION",
      value: .text("일일 근무 시작 알림")
    ))

    // 알람 추가
    event.add(component: alarm1)
    event.add(component: alarm2)

    return event
  }
}
