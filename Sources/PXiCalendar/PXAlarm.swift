import Foundation

extension PXiCalendar {
  public enum PXAlarm: String, Sendable {
    // 필수 속성
    /// 알람 동작 유형 (필수)
    case action = "ACTION"
    /// 알람 트리거 시간 (필수)
    case trigger = "TRIGGER"

    // 조건부 필수 속성
    /// 표시할 설명 (DISPLAY 액션에 필수)
    case description = "DESCRIPTION"
    /// 요약/제목 (EMAIL 액션에 필수)
    case summary = "SUMMARY"
    /// 참석자 이메일 (EMAIL 액션에 필수)
    case attendee = "ATTENDEE"

    // 추가 속성
    /// 첨부 파일 (AUDIO 액션에서 사운드 파일)
    case attach = "ATTACH"

    // 반복 관련 속성
    /// 반복 횟수
    case `repeat` = "REPEAT"
    /// 반복 간격
    case duration = "DURATION"

    // 식별자
    /// 고유 식별자 (선택 사항)
    case uid = "UID"
  }

  public enum AlarmAction: String {
    /// 메시지 표시
    case display = "DISPLAY"
    /// 이메일 전송
    case email = "EMAIL"
    /// 소리 재생
    case audio = "AUDIO"
    /// 절차 호출 (기타 작업)
    case procedure = "PROCEDURE"
  }
}
