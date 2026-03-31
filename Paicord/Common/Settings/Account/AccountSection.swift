//
//  AccountSection.swift
//  Paicord
//
//  Created by Lakhan Lothiyi on 15/11/2025.
//  Copyright © 2025 Lakhan Lothiyi.
//

import SDWebImageSwiftUI
import SettingsKit
import SwiftUI
import DiscordModels

extension SettingsView {
  var accountSection: some SettingsContent {
    SettingsGroup("My Account", systemImage: "person.crop.circle") {
      AccountProfileRow()
        .environment(\.gateway, gw)
      Divider()
        .padding(.vertical, 4)
      SettingsItem("Log Out") {
        AsyncButton("") {
          guard let currentAccount = gw.accounts.currentAccount else { return }
          gw.accounts.removeAccount(currentAccount)
          await gw.logOut()
        } catch: { _ in
        }
      }
    }
  }
}

private struct AccountProfileRow: View {
  @Environment(\.gateway) var gw

  var currentUser: DiscordUser? {
    gw.accounts.currentAccount?.user
  }

  var avatarURL: URL? {
    guard let user = currentUser else { return nil }
    if let avatar = user.avatar {
      let ext = avatar.hasPrefix("a_") ? "gif" : "png"
      return URL(string: "https://cdn.discordapp.com/avatars/\(user.id)/\(avatar).\(ext)?size=128")
    }
    return URL(string: "https://cdn.discordapp.com/embed/avatars/0.png")
  }

  var displayName: String {
    currentUser?.global_name ?? currentUser?.username ?? "Unknown"
  }

  var handle: String {
    guard let user = currentUser else { return "" }
    return user.discriminator == "0" ? "@\(user.username)" : "\(user.username)#\(user.discriminator)"
  }

  var maskedEmail: String? {
    guard let email = currentUser?.email, !email.isEmpty else { return nil }
    let parts = email.split(separator: "@")
    guard parts.count == 2 else { return email }
    return "\(parts[0].prefix(2))***@\(parts[1])"
  }

  var body: some View {
    HStack(spacing: 14) {
      WebImage(url: avatarURL) {_ in 
        Circle().fill(.gray.opacity(0.3))
      }
      .resizable()
      .scaledToFill()
      .frame(width: 56, height: 56)
      .clipShape(Circle())
      .overlay(Circle().stroke(.secondary.opacity(0.15), lineWidth: 1))

      VStack(alignment: .leading, spacing: 3) {
        Text(displayName)
          .font(.headline)
          .lineLimit(1)
        Text(handle)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .lineLimit(1)
        if let email = maskedEmail {
          Text(email)
            .font(.caption)
            .foregroundStyle(.tertiary)
        }
      }

      Spacer()
    }
    .padding(.vertical, 6)
  }
}

