//
//  AdvancedSection.swift
//  Paicord
//
//  Created by Lakhan Lothiyi on 02/12/2025.
//  Copyright © 2025 Lakhan Lothiyi.
//

import SDWebImage
import SettingsKit
import SwiftUI

extension SettingsView {
  var advancedSection: some SettingsContent {
    SettingsGroup("Advanced", systemImage: "gear") {
      AdvancedSettingsView()
    }
  }
}

private struct AdvancedSettingsView: View {
  @AppStorage("Paicord.Advanced.DeveloperMode") var developerMode: Bool = false

  @State private var cacheSize: String = "Calculating…"
  @State private var showClearConfirmation: Bool = false

  var body: some View {
    Section("Cache") {
      LabeledContent("Image Cache", value: cacheSize)
      Button("Clear Image Cache") {
        showClearConfirmation = true
      }
      .confirmationDialog(
        "Clear image cache?",
        isPresented: $showClearConfirmation,
        titleVisibility: .visible
      ) {
        Button("Clear Cache", role: .destructive) {
          SDImageCache.shared.clearMemory()
          SDImageCache.shared.clearDisk {
            refreshCacheSize()
          }
        }
        Button("Cancel", role: .cancel) {}
      } message: {
        Text("Cached images will be re-downloaded as needed.")
      }
    }

    Section {
      Toggle("Developer Mode", isOn: $developerMode)
    } header: {
      Text("Developer")
    } footer: {
      Text("Enables additional logging and diagnostic tools. Only useful if you're building or debugging Paicord.")
    }

    .onAppear {
      refreshCacheSize()
    }
  }

  private func refreshCacheSize() {
    SDImageCache.shared.calculateSize { count, bytes in
      let formatted = ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .file)
      cacheSize = "\(formatted) (\(count) image\(count == 1 ? "" : "s"))"
    }
  }
}

