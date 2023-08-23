// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Settings {
    internal enum EditProfile {
      /// Edit profile
      internal static let title = Strings.tr("Localizable", "Settings.EditProfile.title", fallback: "Edit profile")
    }
    internal enum SecondSession {
      /// Tell a friend
      internal static let tellAFriend = Strings.tr("Localizable", "Settings.SecondSession.tellAFriend", fallback: "Tell a friend")
      /// Terms and conditions
      internal static let termsAndConditions = Strings.tr("Localizable", "Settings.SecondSession.termsAndConditions", fallback: "Terms and conditions")
    }
    internal enum TellAFriend {
      /// Tell a friend
      internal static let title = Strings.tr("Localizable", "Settings.TellAFriend.title", fallback: "Tell a friend")
    }
    internal enum TermsAndConditions {
      /// Terms and conditions
      internal static let title = Strings.tr("Localizable", "Settings.TermsAndConditions.title", fallback: "Terms and conditions")
    }
    internal enum ThirdSection {
      /// Logout
      internal static let logout = Strings.tr("Localizable", "Settings.ThirdSection.logout", fallback: "Logout")
      /// Version 
      internal static let version = Strings.tr("Localizable", "Settings.ThirdSection.version", fallback: "Version ")
    }
  }
  internal enum TabBar {
    internal enum Channels {
      /// Channels
      internal static let title = Strings.tr("Localizable", "TabBar.Channels.title", fallback: "Channels")
    }
    internal enum Chats {
      /// Chats
      internal static let title = Strings.tr("Localizable", "TabBar.Chats.title", fallback: "Chats")
    }
    internal enum Settings {
      /// Settings
      internal static let title = Strings.tr("Localizable", "TabBar.Settings.title", fallback: "Settings")
    }
    internal enum Users {
      /// Users
      internal static let title = Strings.tr("Localizable", "TabBar.Users.title", fallback: "Users")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BabelResources.resourcesBundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
