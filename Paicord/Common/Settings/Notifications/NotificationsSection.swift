//
//  NotificationsSection.swift
//  Paicord
//
//  Created by Lakhan Lothiyi on 02/12/2025.
//  Copyright © 2025 Lakhan Lothiyi.
//

import SettingsKit
import SwiftUI

extension SettingsView {
  var notificationsSection: some SettingsContent {
    SettingsGroup("Notifications", systemImage: "bell.fill") {
      NotificationsSettingsView()
    }
  }
}

private struct NotificationsSettingsView: View {
  @AppStorage("Paicord.Notifications.BadgeCount") var showBadgeCount: Bool = true
  @AppStorage("Paicord.Notifications.MessagePreviews") var messagePreviews: Bool = true
  @AppStorage("Paicord.Notifications.MentionsOnly") var mentionsOnly: Bool = false

  @Environment(\.openURL) var openURL

  var body: some View {
    Section("Alerts") {
      Toggle("Show Badge Count", isOn: $showBadgeCount)
      Toggle("Show Message Previews", isOn: $messagePreviews)
      Toggle("Only Notify on Mentions & DMs", isOn: $mentionsOnly)
    }

    Section {
      Button("Open System Notification Settings") {
        #if os(macOS)
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
          openURL(url)
        }
        #else
        if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
          openURL(url)
        }
        #endif
      }
    } footer: {
      Text("Control which types of alerts Paicord can send from System Settings.")
    }
  }
}
