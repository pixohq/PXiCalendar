//
//  ContentView.swift
//  Example
//
//  Created by 한지석 on 3/6/25.
//

import SwiftUI
import PXiCalendar

struct ContentView: View {
  @State private var isShareSheetPresented = false
  @State private var shareURL: URL?
  @State private var showError = false
  @State private var errorMessage = ""

  var body: some View {
    VStack {
      Button("일정 공유하기") {
        Task {
          try await shareCalendar()
        }
      }
      .padding()
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
    .sheet(isPresented: $isShareSheetPresented) {
      if let url = shareURL {
        ShareSheet(items: [url])
      }
    }
    .alert("오류", isPresented: $showError) {
      Button("확인", role: .cancel) {}
    } message: {
      Text(errorMessage)
    }
  }


  private func shareCalendar() async throws {
    do {
      let recurrenceRule = PXiCalendar.RecurrenceRule(
        recurrence: PXiCalendar.Recurrence.weekly,
        byDay: [.friday]
      )

      let calendar = await PXiCalendarManager.shared.createCalendar(
        calendarName: "calendar",
        calendarDescription: "descriptiopn",
        eventTitle: "eventTitle",
        eventDescription: "eventDescription",
        eventLocation: "eventLocation",
        eventStartDate: Date(),
        eventEndDate: Date(),
        eventIsAllDay: false,
        eventRecurrenceRule: recurrenceRule
      )

      let url = try await PXiCalendarManager.shared.createShareURL(for: calendar)

      await MainActor.run {
        shareURL = url
        isShareSheetPresented = true
      }
    } catch {
      showError.toggle()
    }
  }
}

struct ShareSheet: UIViewControllerRepresentable {
  let items: [URL]

  func makeUIViewController(context: Context) -> UIActivityViewController {
    return UIActivityViewController(
      activityItems: items,
      applicationActivities: nil
    )
  }

  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}

#Preview {
  ContentView()
}
