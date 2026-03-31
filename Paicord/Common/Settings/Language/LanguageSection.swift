//
//  LanguageSection.swift
//  Paicord
//
//  Created by Lakhan Lothiyi on 02/12/2025.
//  Copyright © 2025 Lakhan Lothiyi.
//

import SettingsKit
import SwiftUI

extension SettingsView {
  var languageSection: some SettingsContent {
    SettingsGroup("Language", systemImage: "globe") {
      LanguageSettingsView()
    }
  }
}

private struct LanguageSettingsView: View {
  @Environment(\.openURL) var openURL

  var currentLanguageName: String {
    let code = Locale.current.language.languageCode?.identifier ?? "en"
    return Locale.current.localizedString(forLanguageCode: code) ?? code
  }

  var currentRegionName: String {
    guard let region = Locale.current.region?.identifier else { return "" }
    return Locale.current.localizedString(forRegionCode: region) ?? region
  }

  var body: some View {
    Section("Current") {
      LabeledContent("Language", value: currentLanguageName)
      if !currentRegionName.isEmpty {
        LabeledContent("Region", value: currentRegionName)
      }
    }

    Section {
      Button("Change Language & Region") {
        #if os(macOS)
        if let url = URL(string: "x-apple.systempreferences:com.apple.Localization") {
          openURL(url)
        }
        #else
        if let url = URL(string: "App-Prefs:root=General&path=LANGUAGE_AND_REGION") {
          openURL(url)
        }
        #endif
      }
    } footer: {
      Text("Paicord uses your system language. Language and region preferences are managed in System Settings.")
    }
  }
}
