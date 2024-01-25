// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum ChatView {
    /// Pull to load more
    internal static let pullToLoad = Strings.tr("Localizable", "ChatView.pullToLoad", fallback: "Pull to load more")
    /// Read
    internal static let read = Strings.tr("Localizable", "ChatView.read", fallback: "Read")
    /// Send
    internal static let send = Strings.tr("Localizable", "ChatView.send", fallback: "Send")
    /// Sent
    internal static let sent = Strings.tr("Localizable", "ChatView.sent", fallback: "Sent")
    /// Typing...
    internal static let typing = Strings.tr("Localizable", "ChatView.typing", fallback: "Typing...")
    internal enum ActionSheet {
      /// Camera
      internal static let camera = Strings.tr("Localizable", "ChatView.ActionSheet.camera", fallback: "Camera")
      /// Cancel
      internal static let cancel = Strings.tr("Localizable", "ChatView.ActionSheet.cancel", fallback: "Cancel")
      /// Library
      internal static let library = Strings.tr("Localizable", "ChatView.ActionSheet.library", fallback: "Library")
      /// Share location
      internal static let shareLocation = Strings.tr("Localizable", "ChatView.ActionSheet.shareLocation", fallback: "Share location")
    }
  }
  internal enum Commons {
    /// Add
    internal static let add = Strings.tr("Localizable", "Commons.add", fallback: "Add")
    /// All users
    internal static let allUsers = Strings.tr("Localizable", "Commons.allUsers", fallback: "All users")
    /// Cancel
    internal static let cancel = Strings.tr("Localizable", "Commons.cancel", fallback: "Cancel")
    /// Description
    internal static let description = Strings.tr("Localizable", "Commons.description", fallback: "Description")
    /// Done
    internal static let done = Strings.tr("Localizable", "Commons.done", fallback: "Done")
    /// Edit
    internal static let edit = Strings.tr("Localizable", "Commons.edit", fallback: "Edit")
    /// Logout
    internal static let logout = Strings.tr("Localizable", "Commons.logout", fallback: "Logout")
    /// Are you sure you want to logout? You will have to login with your credentials again
    internal static let logoutDescription = Strings.tr("Localizable", "Commons.logoutDescription", fallback: "Are you sure you want to logout? You will have to login with your credentials again")
    /// Search
    internal static let search = Strings.tr("Localizable", "Commons.search", fallback: "Search")
    /// Send message
    internal static let sendMessage = Strings.tr("Localizable", "Commons.sendMessage", fallback: "Send message")
    /// Users
    internal static let users = Strings.tr("Localizable", "Commons.users", fallback: "Users")
  }
  internal enum ContactInfo {
    /// Contact Info
    internal static let title = Strings.tr("Localizable", "ContactInfo.title", fallback: "Contact Info")
  }
  internal enum CreateGroup {
    /// Create
    internal static let createButton = Strings.tr("Localizable", "CreateGroup.createButton", fallback: "Create")
    /// Group name
    internal static let groupNamePlaceholder = Strings.tr("Localizable", "CreateGroup.groupNamePlaceholder", fallback: "Group name")
    /// Create new group
    internal static let title = Strings.tr("Localizable", "CreateGroup.title", fallback: "Create new group")
  }
  internal enum GenericError {
    /// Ops! Something went wrong
    internal static let message = Strings.tr("Localizable", "GenericError.message", fallback: "Ops! Something went wrong")
  }
  internal enum GroupInfo {
    /// Add group description
    internal static let addGroupDescription = Strings.tr("Localizable", "GroupInfo.addGroupDescription", fallback: "Add group description")
    /// Add new member
    internal static let addNewMember = Strings.tr("Localizable", "GroupInfo.addNewMember", fallback: "Add new member")
    /// The group description is visible to members of this group and people invited to this group.
    internal static let descriptionInfo = Strings.tr("Localizable", "GroupInfo.descriptionInfo", fallback: "The group description is visible to members of this group and people invited to this group.")
    /// Exit group
    internal static let exitGroup = Strings.tr("Localizable", "GroupInfo.exitGroup", fallback: "Exit group")
    /// Group name
    internal static let groupNamePlaceholder = Strings.tr("Localizable", "GroupInfo.groupNamePlaceholder", fallback: "Group name")
    /// Join group
    internal static let joinGroup = Strings.tr("Localizable", "GroupInfo.joinGroup", fallback: "Join group")
    /// Members
    internal static let members = Strings.tr("Localizable", "GroupInfo.members", fallback: "Members")
    /// Group info
    internal static let title = Strings.tr("Localizable", "GroupInfo.title", fallback: "Group info")
    /// Users requests
    internal static let usersRequests = Strings.tr("Localizable", "GroupInfo.usersRequests", fallback: "Users requests")
    internal enum ActionSheet {
      /// Do you want to exit this group?
      internal static let exitGroupQuestion = Strings.tr("Localizable", "GroupInfo.ActionSheet.exitGroupQuestion", fallback: "Do you want to exit this group?")
      /// Do you want to join this group?
      internal static let joinGroupQuestion = Strings.tr("Localizable", "GroupInfo.ActionSheet.joinGroupQuestion", fallback: "Do you want to join this group?")
      /// Make admin
      internal static let makeAdmin = Strings.tr("Localizable", "GroupInfo.ActionSheet.makeAdmin", fallback: "Make admin")
      /// Remove admin
      internal static let removeAdmin = Strings.tr("Localizable", "GroupInfo.ActionSheet.removeAdmin", fallback: "Remove admin")
      /// Remove member
      internal static let removeMember = Strings.tr("Localizable", "GroupInfo.ActionSheet.removeMember", fallback: "Remove member")
      /// User info
      internal static let userInfo = Strings.tr("Localizable", "GroupInfo.ActionSheet.userInfo", fallback: "User info")
    }
  }
  internal enum MapView {
    /// Map view
    internal static let title = Strings.tr("Localizable", "MapView.title", fallback: "Map view")
  }
  internal enum MessageInputBar {
    /// Swipe to cancel
    internal static let swipeToCancel = Strings.tr("Localizable", "MessageInputBar.swipeToCancel", fallback: "Swipe to cancel")
  }
  internal enum MessageType {
    /// Audio
    internal static let audio = Strings.tr("Localizable", "MessageType.audio", fallback: "Audio")
    /// Location
    internal static let location = Strings.tr("Localizable", "MessageType.location", fallback: "Location")
    /// Photo
    internal static let photo = Strings.tr("Localizable", "MessageType.photo", fallback: "Photo")
    /// Video
    internal static let video = Strings.tr("Localizable", "MessageType.video", fallback: "Video")
  }
  internal enum OpenAI {
    internal enum ChatBot {
      /// Chat bot with messages only
      internal static let description = Strings.tr("Localizable", "OpenAI.ChatBot.description", fallback: "Chat bot with messages only")
      /// Chat bot
      internal static let title = Strings.tr("Localizable", "OpenAI.ChatBot.title", fallback: "Chat bot")
    }
    internal enum ImageGenerator {
      /// Generate images through AI
      internal static let description = Strings.tr("Localizable", "OpenAI.ImageGenerator.description", fallback: "Generate images through AI")
      /// Image generator
      internal static let title = Strings.tr("Localizable", "OpenAI.ImageGenerator.title", fallback: "Image generator")
    }
  }
  internal enum RecentChat {
    internal enum ActionSheet {
      internal enum Delete {
        /// Do you want to delete this chat?
        internal static let description = Strings.tr("Localizable", "RecentChat.ActionSheet.Delete.description", fallback: "Do you want to delete this chat?")
        /// Chat bot
        internal static let title = Strings.tr("Localizable", "RecentChat.ActionSheet.Delete.title", fallback: "Chat bot")
      }
    }
  }
  internal enum Settings {
    /// Version
    internal static let version = Strings.tr("Localizable", "Settings.version", fallback: "Version")
    internal enum EditProfile {
      /// Full name
      internal static let namePlaceholder = Strings.tr("Localizable", "Settings.EditProfile.namePlaceholder", fallback: "Full name")
      /// Edit profile
      internal static let title = Strings.tr("Localizable", "Settings.EditProfile.title", fallback: "Edit profile")
    }
    internal enum TellAFriend {
      /// Tell a friend
      internal static let title = Strings.tr("Localizable", "Settings.TellAFriend.title", fallback: "Tell a friend")
    }
    internal enum TermsAndConditions {
      /// Terms and conditions
      internal static let title = Strings.tr("Localizable", "Settings.TermsAndConditions.title", fallback: "Terms and conditions")
    }
  }
  internal enum SystemSettings {
    /// Clear
    internal static let clear = Strings.tr("Localizable", "SystemSettings.clear", fallback: "Clear")
    /// Clear cache
    internal static let clearCache = Strings.tr("Localizable", "SystemSettings.clearCache", fallback: "Clear cache")
    /// Do you want to clear cache?
    internal static let clearCacheDescription = Strings.tr("Localizable", "SystemSettings.clearCacheDescription", fallback: "Do you want to clear cache?")
    /// System settings
    internal static let title = Strings.tr("Localizable", "SystemSettings.title", fallback: "System settings")
  }
  internal enum TabBar {
    internal enum Chats {
      /// Chats
      internal static let title = Strings.tr("Localizable", "TabBar.Chats.title", fallback: "Chats")
    }
    internal enum Groups {
      /// Groups
      internal static let title = Strings.tr("Localizable", "TabBar.Groups.title", fallback: "Groups")
    }
    internal enum OpenAI {
      /// Open AI
      internal static let title = Strings.tr("Localizable", "TabBar.OpenAI.title", fallback: "Open AI")
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
