import Foundation

extension PXiCalendar {

  public struct Calendar {
    public var properties: [Property]
    public var components: [Component]

    public init(properties: [Property] = [], components: [Component] = []) {
      self.properties = properties
      self.components = components

      if !properties.contains(where: { $0.name == PXCalendar.prodid.rawValue }) {
        self.properties.append(
          .init(
            name: PXCalendar.prodid.rawValue,
            value: .text("-//YourCompany//YourApp//EN")
          )
        )
      }

      if !properties.contains(where: { $0.name == PXCalendar.version.rawValue }) {
        self.properties.append(
          .init(
            name: PXCalendar.version.rawValue,
            value: .text("2.0")
          )
        )
      }
    }

    public func asiCalendarString() -> String {
      var calendar = Component(type: .calendar)

      for property in properties {
        calendar.add(property: property)
      }

      for component in components {
        calendar.add(component: component)
      }

      return calendar.asiCalendarString()
    }

    public mutating func add(property: Property) {
      properties.append(property)
    }

    public mutating func add(component: Component) {
      components.append(component)
    }
  }

  public enum PXCalendar: String, Sendable {
    // 필수 속성

    /// 제품 식별자
    case prodid = "PRODID"
    /// 버전 (2.0)
    case version = "VERSION"

    // 옵셔널

    /// 캘린더 시스템 (기본값: GREGORIAN)
    case calscale = "CALSCALE"
    /// 일정 처리 방법 (PUBLISH, REQUEST 등)
    case method = "METHOD"
    /// 캘린더 이름
    case name = "NAME"
    /// 캘린더 설명
    case description = "DESCRIPTION"
    /// 새로고침 간격
    case refreshInterval = "REFRESH-INTERVAL"
    /// 색상 (RFC 7986)
    case color = "COLOR"
    /// 기본 시간대
    case timezone = "TIMEZONE"
    /// 관련 URL
    case url = "URL"
    /// 캘린더 고유 식별자
    case uid = "UID"
    /// 소스 URL
    case source = "SOURCE"
    /// 마지막 수정 시간
    case lastModified = "LAST-MODIFIED"
  }

  public enum CalendarMethod: String {
    /// 일방적인 공개 (기본값)
    case publish = "PUBLISH"
    /// 요청 (회의 초대 등)
    case request = "REQUEST"
    /// 응답 (초대 수락/거절 등)
    case reply = "REPLY"
    /// 일정 추가
    case add = "ADD"
    /// 일정 취소
    case cancel = "CANCEL"
    /// 새로고침 요청
    case refresh = "REFRESH"
    /// 대안 제안
    case counter = "COUNTER"
    /// 대안 거절
    case declineCounter = "DECLINECOUNTER"
  }
}
