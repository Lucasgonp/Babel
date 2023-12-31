// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum ChatView {
    /// Send
    internal static let send = Strings.tr("Localizable", "ChatView.send", fallback: "Send")
    /// Typing...
    internal static let typing = Strings.tr("Localizable", "ChatView.typing", fallback: "Typing...")
    internal enum MessageStatus {
      /// Sent
      internal static let sent = Strings.tr("Localizable", "ChatView.MessageStatus.sent", fallback: "Sent")
    }
  }
  internal enum Commons {
    /// Done
    internal static let done = Strings.tr("Localizable", "Commons.done", fallback: "Done")
  }
  internal enum ContactInfo {
    /// Contact Info
    internal static let title = Strings.tr("Localizable", "ContactInfo.title", fallback: "Contact Info")
  }
  internal enum Settings {
    internal enum EditProfile {
      /// Full name
      internal static let namePlaceholder = Strings.tr("Localizable", "Settings.EditProfile.namePlaceholder", fallback: "Full name")
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
  internal enum UserBio {
    /// Currently set to
    internal static let currentTitle = Strings.tr("Localizable", "UserBio.currentTitle", fallback: "Currently set to")
    /// Select your about
    internal static let optionsTitle = Strings.tr("Localizable", "UserBio.optionsTitle", fallback: "Select your about")
    /// About
    internal static let placeholder = Strings.tr("Localizable", "UserBio.placeholder", fallback: "About")
    /// About
    internal static let title = Strings.tr("Localizable", "UserBio.title", fallback: "About")
    internal enum Options {
      /// At school
      internal static let atSchool = Strings.tr("Localizable", "UserBio.Options.atSchool", fallback: "At school")
      /// At the gym
      internal static let atTheGym = Strings.tr("Localizable", "UserBio.Options.atTheGym", fallback: "At the gym")
      /// At the movies
      internal static let atTheMovies = Strings.tr("Localizable", "UserBio.Options.atTheMovies", fallback: "At the movies")
      /// At work
      internal static let atWork = Strings.tr("Localizable", "UserBio.Options.atWork", fallback: "At work")
      /// Available
      internal static let available = Strings.tr("Localizable", "UserBio.Options.available", fallback: "Available")
      /// Battery about to die
      internal static let batteryAboutToDie = Strings.tr("Localizable", "UserBio.Options.batteryAboutToDie", fallback: "Battery about to die")
      /// Busy
      internal static let busy = Strings.tr("Localizable", "UserBio.Options.busy", fallback: "Busy")
      /// Can't talk
      internal static let cantTalk = Strings.tr("Localizable", "UserBio.Options.cantTalk", fallback: "Can't talk")
      /// In a metting
      internal static let inAMetting = Strings.tr("Localizable", "UserBio.Options.inAMetting", fallback: "In a metting")
      /// Sleeping
      internal static let sleeping = Strings.tr("Localizable", "UserBio.Options.sleeping", fallback: "Sleeping")
      /// Urgent calls only
      internal static let urgentCallsOnly = Strings.tr("Localizable", "UserBio.Options.urgentCallsOnly", fallback: "Urgent calls only")
      /// Hello there! I'm using Babel!
      internal static let wellcome = Strings.tr("Localizable", "UserBio.Options.wellcome", fallback: "Hello there! I'm using Babel!")
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
