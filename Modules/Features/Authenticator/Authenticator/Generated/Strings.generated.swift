// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Error {
    internal enum Field {
      /// Email is invalid
      internal static let emailEmpty = Strings.tr("Localizable", "Error.Field.emailEmpty", fallback: "Email is invalid")
      /// Email is invalid
      internal static let emailInvalid = Strings.tr("Localizable", "Error.Field.emailInvalid", fallback: "Email is invalid")
      /// Full name is required
      internal static let fullnameEmpty = Strings.tr("Localizable", "Error.Field.fullnameEmpty", fallback: "Full name is required")
      /// Password is required
      internal static let passwordEmpty = Strings.tr("Localizable", "Error.Field.passwordEmpty", fallback: "Password is required")
      /// Username is required
      internal static let usernameEmpty = Strings.tr("Localizable", "Error.Field.usernameEmpty", fallback: "Username is required")
    }
  }
  internal enum Login {
    internal enum Button {
      /// Login
      internal static let login = Strings.tr("Localizable", "Login.Button.login", fallback: "Login")
      /// Don't have an account? **Sign Up**
      internal static let register = Strings.tr("Localizable", "Login.Button.register", fallback: "Don't have an account? **Sign Up**")
    }
    internal enum Field {
      internal enum Email {
        /// Email
        internal static let placeholder = Strings.tr("Localizable", "Login.Field.Email.placeholder", fallback: "Email")
      }
      internal enum Password {
        /// Password
        internal static let placeholder = Strings.tr("Localizable", "Login.Field.Password.placeholder", fallback: "Password")
      }
    }
  }
  internal enum Register {
    internal enum Button {
      /// Already have an account? **Login**
      internal static let login = Strings.tr("Localizable", "Register.Button.login", fallback: "Already have an account? **Login**")
      /// Register
      internal static let register = Strings.tr("Localizable", "Register.Button.register", fallback: "Register")
    }
    internal enum Field {
      internal enum Email {
        /// Email
        internal static let placeholder = Strings.tr("Localizable", "Register.Field.Email.placeholder", fallback: "Email")
      }
      internal enum FullName {
        /// Full Name
        internal static let placeholder = Strings.tr("Localizable", "Register.Field.FullName.placeholder", fallback: "Full Name")
      }
      internal enum Password {
        /// Password
        internal static let placeholder = Strings.tr("Localizable", "Register.Field.Password.placeholder", fallback: "Password")
      }
      internal enum Username {
        /// Username
        internal static let placeholder = Strings.tr("Localizable", "Register.Field.Username.placeholder", fallback: "Username")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = AuthenticatorResources.resourcesBundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
