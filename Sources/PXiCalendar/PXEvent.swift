import Foundation

extension PXiCalendar {
  
  public enum PXEvent: String, Sendable {

    // 식별 속성
    /// 고유 식별자 (필수)
    case uid = "UID"
    /// 생성 시간 (필수)
    case dtstamp = "DTSTAMP"

    // 일정 시간 관련 속성
    /// 시작 시간 (필수)
    case dtstart = "DTSTART"
    /// 종료 시간
    case dtend = "DTEND"
    /// 지속 시간 (DTEND와 동시 사용 불가)
    case duration = "DURATION"

    // 반복 관련 속성
    /// 반복 규칙
    case rrule = "RRULE"
    /// 반복 날짜
    case rdate = "RDATE"
    /// 예외 날짜
    case exdate = "EXDATE"
    /// 예외 규칙 (사용 비권장)
    case exrule = "EXRULE"

    // 설명 속성
    /// 제목/요약
    case summary = "SUMMARY"
    /// 설명
    case description = "DESCRIPTION"
    /// 주석
    case comment = "COMMENT"
    /// 위치
    case location = "LOCATION"
    /// 지리 좌표
    case geo = "GEO"

    // 상태 속성
    /// 상태 (CONFIRMED, TENTATIVE, CANCELLED)
    case status = "STATUS"
    /// 투명도 (OPAQUE, TRANSPARENT)
    case transp = "TRANSP"
    /// 보안 분류 (PUBLIC, PRIVATE, CONFIDENTIAL)
    case `class` = "CLASS"

    // 참석자 관련 속성
    /// 주최자
    case organizer = "ORGANIZER"
    /// 참석자
    case attendee = "ATTENDEE"

    // 기타 속성
    /// 생성 시간
    case created = "CREATED"
    /// 마지막 수정 시간
    case lastModified = "LAST-MODIFIED"
    /// 수정 시퀀스 번호
    case sequence = "SEQUENCE"
    /// 우선순위 (0-9)
    case priority = "PRIORITY"
    /// 카테고리
    case categories = "CATEGORIES"
    /// 관련 URL
    case url = "URL"
    /// 필요한 자원
    case resources = "RESOURCES"
    /// 반복 식별자
    case recurrenceId = "RECURRENCE-ID"
    /// 첨부파일
    case attachment = "ATTACH"
    /// 색상 (RFC 7986)
    case color = "COLOR"
  }
}
