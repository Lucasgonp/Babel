// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Alert {
    /// Got it
    internal static let gotIt = Strings.tr("Localizable", "Alert.gotIt", fallback: "Got it")
    /// Later
    internal static let later = Strings.tr("Localizable", "Alert.later", fallback: "Later")
    /// Close
    internal static let ok = Strings.tr("Localizable", "Alert.ok", fallback: "Close")
  }
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
    internal enum Alert {
      internal enum EmailVerification {
        internal enum Resend {
          /// Check the email we already sent to you, if you need to resend the validation just click Resend validation
          internal static let message = Strings.tr("Localizable", "Login.Alert.EmailVerification.Resend.message", fallback: "Check the email we already sent to you, if you need to resend the validation just click Resend validation")
          /// Resend
          internal static let resendButton = Strings.tr("Localizable", "Login.Alert.EmailVerification.Resend.resendButton", fallback: "Resend")
          /// Validate you email first
          internal static let title = Strings.tr("Localizable", "Login.Alert.EmailVerification.Resend.title", fallback: "Validate you email first")
        }
        internal enum Resent {
          /// We just resent a varification to your email, please validate before login
          internal static let message = Strings.tr("Localizable", "Login.Alert.EmailVerification.Resent.message", fallback: "We just resent a varification to your email, please validate before login")
          /// Email sent
          internal static let title = Strings.tr("Localizable", "Login.Alert.EmailVerification.Resent.title", fallback: "Email sent")
        }
      }
    }
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
    internal enum Alert {
      internal enum EmailVerification {
        internal enum Verify {
          /// Please check your email inbox we just sent you, you need to validate before login
          internal static let message = Strings.tr("Localizable", "Register.Alert.EmailVerification.Verify.message", fallback: "Please check your email inbox we just sent you, you need to validate before login")
          /// Email verification sent
          internal static let title = Strings.tr("Localizable", "Register.Alert.EmailVerification.Verify.title", fallback: "Email verification sent")
        }
      }
    }
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
  internal enum ResetPassword {
    internal enum SendReset {
      /// Please type your EMAIL bellow so we can send you an email with instructions to reset the password
      internal static let message = Strings.tr("Localizable", "ResetPassword.SendReset.message", fallback: "Please type your EMAIL bellow so we can send you an email with instructions to reset the password")
      /// Reset password
      internal static let resetButton = Strings.tr("Localizable", "ResetPassword.SendReset.resetButton", fallback: "Reset password")
      /// Reset password
      internal static let title = Strings.tr("Localizable", "ResetPassword.SendReset.title", fallback: "Reset password")
    }
    internal enum SentReset {
      /// Please follow the instructions we sent you by email so you you can reset your password
      internal static let message = Strings.tr("Localizable", "ResetPassword.SentReset.message", fallback: "Please follow the instructions we sent you by email so you you can reset your password")
      /// Reset password
      internal static let title = Strings.tr("Localizable", "ResetPassword.SentReset.title", fallback: "Reset password")
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
