//
//  AccessibilitySection.swift
//  Paicord
//
//  Created by Lakhan Lothiyi on 02/12/2025.
//  Copyright © 2025 Lakhan Lothiyi.
//

import SettingsKit
import SwiftUI

extension SettingsView {
  var accessibilitySection: some SettingsContent {
    SettingsGroup("Accessibility", systemImage: "accessibility.fill") {
      AccessibilitySettingsView()
    }
  }
}

private struct AccessibilitySettingsView: View {
  @AppStorage("Paicord.Accessibility.ReduceMotion") var reduceMotion: Bool = false
  @AppStorage("Paicord.Accessibility.LargeText") var largeText: Bool = false
  @AppStorage("Paicord.Accessibility.HighContrast") var highContrast: Bool = false

  @Environment(\.openURL) var openURL

  var body: some View {
    Section("Motion & Animation") {
      Toggle("Reduce Motion", isOn: $reduceMotion)
        .onChange(of: reduceMotion) { _, newValue in
          // Propagates to Paicord.Appearance.ChatMessagesAnimated so animations
          // are suppressed app-wide when this is enabled.
          if newValue {
            UserDefaults.standard.set(false, forKey: "Paicord.Appearance.ChatMessagesAnimated")
          }
        }
    }

    Section("Display") {
      Toggle("Larger Text", isOn: $largeText)
      Toggle("Increase Contrast", isOn: $highContrast)
    }

    Section {
      Button("Open System Accessibility Settings") {
        #if os(macOS)
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.universalaccess") {
          openURL(url)
        }
        #else
        if let url = URL(string: "App-Prefs:root=ACCESSIBILITY") {
          openURL(url)
        }
        #endif
      }
    } footer: {
      Text("System-level features like VoiceOver, switch control, and display accommodations can be configured in System Settings.")
    }
  }
}
